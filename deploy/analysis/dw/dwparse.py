#!/usr/bin/env python3
"""Parse recovered PowerBuilder DataWindow .srd exports.

Read-only. Emits dw_metrics.json + dw_metrics.csv for downstream ranking.
"""
import json
import os
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(r"C:\Projects\Abuzar")
DWROOT = ROOT / "recovered" / "datawindows"
SCRIPTROOT = ROOT / "recovered" / "scripts"
OUT = Path(__file__).resolve().parent

FUNC_ON_COL = re.compile(
    r"\b(CONVERT|CAST|ISNULL|COALESCE|UPPER|LOWER|SUBSTRING|LEFT|RIGHT|"
    r"DATEPART|DATEDIFF|DATEADD|ROUND|ABS|LTRIM|RTRIM|REPLACE|STR|"
    r"YEAR|MONTH|DAY)\s*\(", re.I)
DATE_FUNC = re.compile(r"\b(DATEPART|DATEDIFF|DATEADD|CONVERT|CAST|YEAR|MONTH|DAY)\b", re.I)


def unescape_pb(s: str) -> str:
    # PB export escapes: ~" -> ", ~~ -> ~, ~n ~r ~t
    out = []
    i = 0
    while i < len(s):
        c = s[i]
        if c == "~" and i + 1 < len(s):
            n = s[i + 1]
            out.append({"n": "\n", "r": "\r", "t": "\t", '"': '"', "~": "~"}.get(n, n))
            i += 2
        else:
            out.append(c)
            i += 1
    return "".join(out)


def extract_assignment(text: str, key: str = "retrieve="):
    """Return (value, start_index, end_index) for key="...", honouring ~ escapes."""
    i = text.find(key)
    if i < 0:
        return None, -1, -1
    j = i + len(key)
    if j >= len(text) or text[j] != '"':
        # non-quoted form e.g. retrieve=(...) -- bail
        return None, i, i
    j += 1
    buf = []
    while j < len(text):
        c = text[j]
        if c == "~" and j + 1 < len(text):
            buf.append(text[j:j + 2])
            j += 2
            continue
        if c == '"':
            break
        buf.append(c)
        j += 1
    return unescape_pb("".join(buf)), i, j + 1


def balanced(text: str, start: int):
    """start points at '('; return (inner, end_index) handling nesting and ~ quotes."""
    depth = 0
    i = start
    inq = False
    while i < len(text):
        c = text[i]
        if c == "~":
            i += 2
            continue
        if c == '"':
            inq = not inq
            i += 1
            continue
        if not inq:
            if c == "(":
                depth += 1
            elif c == ")":
                depth -= 1
                if depth == 0:
                    return text[start + 1:i], i
        i += 1
    return text[start + 1:], len(text)


def attrs(inner: str) -> dict:
    d = {}
    for m in re.finditer(r'([A-Za-z_][\w.]*)\s*=\s*("(?:[^"~]|~.)*"|[^\s]+)', inner):
        k = m.group(1).lower()
        v = m.group(2)
        if v.startswith('"') and v.endswith('"'):
            v = unescape_pb(v[1:-1])
        d[k] = v
    return d


def strip_sql(sql: str) -> str:
    sql = re.sub(r"/\*.*?\*/", " ", sql, flags=re.S)
    sql = re.sub(r"--[^\n]*", " ", sql)
    return re.sub(r"\s+", " ", sql).strip()


IDENT = r"(?:\[[^\]]+\]|[A-Za-z_#@][\w$#@]*)(?:\s*\.\s*(?:\[[^\]]+\]|[A-Za-z_#@][\w$#@]*))?"


TOKEN_RE = re.compile(
    r"""(\s+)|("(?:[^"~]|~.)*"|'(?:[^']|'')*')|([(),])|([A-Za-z_#@\[\]][\w$#@\[\]]*(?:\s*\.\s*[A-Za-z_#@\[\]][\w$#@\[\]]*)*)|(.)""",
    re.S)
CLAUSE = {"WHERE", "GROUP", "ORDER", "HAVING", "UNION", "FOR", "OPTION",
          "ON", "INNER", "LEFT", "RIGHT", "FULL", "CROSS", "OUTER", "SET"}


def top_level_from_tables(sql: str):
    """Token scan: collect table refs after FROM/JOIN and comma-lists in a FROM clause."""
    toks = []
    for m in TOKEN_RE.finditer(sql):
        w = m.group(4)
        if w:
            toks.append(("w", w.strip()))
        elif m.group(3):
            toks.append(("p", m.group(3)))
        elif m.group(2):
            toks.append(("lit", m.group(2)))
        elif m.group(5) and m.group(5).strip():
            toks.append(("o", m.group(5)))
    tables = []
    depth = 0
    from_depths = {}  # depth -> True while inside a FROM list
    i = 0
    while i < len(toks):
        typ, val = toks[i]
        if typ == "p" and val == "(":
            depth += 1
            i += 1
            continue
        if typ == "p" and val == ")":
            from_depths.pop(depth, None)
            depth = max(0, depth - 1)
            i += 1
            continue
        if typ == "w":
            U = val.upper()
            if U in ("FROM", "JOIN"):
                from_depths[depth] = True
                nxt = toks[i + 1] if i + 1 < len(toks) else ("", "")
                if nxt[0] == "w" and nxt[1].upper() not in CLAUSE and nxt[1].upper() not in ("SELECT", "AS"):
                    tables.append(nxt[1])
                    i += 2
                else:
                    i += 1
                continue
            if U in CLAUSE:
                if U in ("WHERE", "GROUP", "ORDER", "HAVING", "UNION", "FOR", "OPTION"):
                    from_depths.pop(depth, None)
                i += 1
                continue
            i += 1
            continue
        if typ == "p" and val == "," and from_depths.get(depth):
            nxt = toks[i + 1] if i + 1 < len(toks) else ("", "")
            if nxt[0] == "w" and nxt[1].upper() not in CLAUSE:
                tables.append(nxt[1])
        i += 1
    return tables


def base_table(name: str):
    n = name.replace("[", "").replace("]", "").replace(" ", "")
    n = n.split(".")[-1]
    return n


def analyze_sql(sql: str, is_pbselect: bool):
    m = {"is_pbselect": is_pbselect}
    s = strip_sql(sql)
    u = s.upper()
    m["sql_len"] = len(s)
    m["sql"] = s
    m["select_star"] = 1 if re.search(r"\bSELECT\s+(?:DISTINCT\s+|TOP\s+\d+\s+|ALL\s+)*\*", u) else 0
    m["distinct"] = 1 if re.search(r"\bSELECT\s+DISTINCT\b", u) else 0
    m["top"] = 1 if re.search(r"\bTOP\s+\d+", u) else 0
    m["top_n"] = None
    tm = re.search(r"\bTOP\s+(\d+)", u)
    if tm:
        m["top_n"] = int(tm.group(1))
    m["order_by"] = 1 if re.search(r"\bORDER\s+BY\b", u) else 0
    m["group_by"] = 1 if re.search(r"\bGROUP\s+BY\b", u) else 0
    m["having"] = 1 if re.search(r"\bHAVING\b", u) else 0
    m["union"] = len(re.findall(r"\bUNION\b", u))
    m["subqueries"] = len(re.findall(r"\(\s*SELECT\b", u))
    m["cte"] = 1 if re.search(r"\bWITH\s+\w+\s+AS\s*\(", u) else 0
    m["not_in"] = len(re.findall(r"\bNOT\s+IN\b", u))
    m["in_subquery"] = len(re.findall(r"\bIN\s*\(\s*SELECT\b", u))
    m["exists"] = len(re.findall(r"\bEXISTS\b", u))
    m["or_count"] = len(re.findall(r"\bOR\b", u))
    m["case_count"] = len(re.findall(r"\bCASE\b", u))
    m["like_prefix"] = len(re.findall(r"\bLIKE\s+'%", u))
    m["like_any"] = len(re.findall(r"\bLIKE\b", u))
    m["getdate"] = len(re.findall(r"\bGETDATE\s*\(", u))
    m["func_on_col"] = len(FUNC_ON_COL.findall(u))
    m["date_func"] = len(DATE_FUNC.findall(u))
    m["isnull"] = len(re.findall(r"\bISNULL\s*\(", u))
    m["convert"] = len(re.findall(r"\bCONVERT\s*\(", u))
    m["cast"] = len(re.findall(r"\bCAST\s*\(", u))
    m["temp_table"] = len(re.findall(r"#[A-Za-z_]\w*", s))
    m["exec"] = 1 if re.search(r"^\s*(EXEC|EXECUTE|CALL)\b", u) else 0
    m["nolock"] = len(re.findall(r"\bNOLOCK\b", u))
    m["option_hint"] = 1 if re.search(r"\bOPTION\s*\(", u) else 0
    m["cross_join"] = len(re.findall(r"\bCROSS\s+JOIN\b", u))
    m["outer_join"] = len(re.findall(r"\b(LEFT|RIGHT|FULL)\s+(OUTER\s+)?JOIN\b", u))
    m["join_kw"] = len(re.findall(r"\bJOIN\b", u))
    m["comma_join"] = 0
    m["tables"] = []
    m["n_tables"] = 0
    m["n_joins"] = 0
    if not is_pbselect:
        tabs = top_level_from_tables(s)
        # unique case-insensitively, drop aliases that are keywords
        seen = []
        for t in tabs:
            b = base_table(t)
            if b and b.upper() not in ("SELECT", "WHERE"):
                if b.lower() not in [x.lower() for x in seen]:
                    seen.append(b)
        m["tables"] = seen
        m["n_tables"] = len(seen)
        # count joins: JOIN keywords + comma-joined tables
        m["n_joins"] = m["join_kw"] + max(0, len(tabs) - len(seen))
        if m["n_tables"] > 1 and m["join_kw"] == 0:
            m["comma_join"] = m["n_tables"] - 1
            m["n_joins"] = m["comma_join"]
        # scalar subquery projects (in SELECT list)
        fm = re.search(r"\bFROM\b", u)
        m["scalar_subquery"] = len(re.findall(r"\(\s*SELECT\b", u[:fm.start()])) if fm else 0
        # where clause characteristics
        wm = re.search(r"\bWHERE\b(.*?)(?:\bGROUP\s+BY\b|\bORDER\s+BY\b|\bHAVING\b|\bUNION\b|$)", s, re.I | re.S)
        where = wm.group(1) if wm else ""
        m["where_len"] = len(where)
        m["where_has_or"] = len(re.findall(r"\bOR\b", where, re.I))
        m["where_func_col"] = len(FUNC_ON_COL.findall(where.upper()))
        m["where_has_date_col"] = 1 if re.search(r"\b(DATEPART|DATEDIFF|CONVERT|CAST|YEAR|MONTH|DAY)\s*\([^)]*"
                                                  r"(DATE|_DATE|DATE_|TIME|DATETIME|DT)\w*", where, re.I) else 0
        m["where_range"] = 1 if re.search(r"(>=|>|BETWEEN)\s*[:'@\w]", where) and re.search(r"(<=|<|BETWEEN)\s*[:'@\w]", where) else 0
        m["where_arg"] = len(re.findall(r"[:@][A-Za-z_]\w*", where))
        m["n_predicates"] = len(re.findall(r"\b(AND|OR)\b", where, re.I)) + 1 if where.strip() else 0
    else:
        # PBSELECT: TABLE(NAME=...) / JOIN(...) / WHERE(...)
        tabs = re.findall(r'TABLE\s*\(\s*NAME\s*=\s*~?"?([\w\.\[\]#]+)', sql, re.I)
        m["tables"] = [base_table(t) for t in tabs]
        m["n_tables"] = len(set(t.lower() for t in m["tables"]))
        m["n_joins"] = max(0, m["n_tables"] - 1)
        m["pbs_where"] = len(re.findall(r"\bWHERE\s*\(", sql, re.I))
        m["pbs_join"] = len(re.findall(r"\bJOIN\s*\(", sql, re.I))
        m["pbs_group"] = len(re.findall(r"\bGROUP\s*\(", sql, re.I))
        m["pbs_order"] = len(re.findall(r"\bORDER\s*\(", sql, re.I))
        m["scalar_subquery"] = 0
        m["where_len"] = 0
        m["where_has_or"] = 0
        m["where_func_col"] = 0
        m["where_has_date_col"] = 0
        m["where_range"] = 0
        m["where_arg"] = 0
        m["n_predicates"] = m["pbs_where"]
    return m


def parse_dw(path: Path):
    raw = path.read_text(encoding="latin-1")
    rel = path.relative_to(DWROOT)
    lib = rel.parts[0]
    name = path.stem
    d = {
        "lib": lib, "name": name, "path": str(rel).replace("\\", "/"),
        "bytes": path.stat().st_size,
        "parse_error": None,
    }
    # ---- datawindow header
    hm = re.search(r"datawindow\s*\(", raw, re.I)
    hdr = attrs(balanced(raw, hm.end() - 1)[0]) if hm else {}
    d["dw_processing"] = hdr.get("processing")
    d["dw_timer"] = hdr.get("timer_interval")
    d["dw_units"] = hdr.get("units")

    # ---- retrieve SQL
    sql, rs, re_ = extract_assignment(raw, "retrieve=")
    d["has_retrieve"] = sql is not None
    d["retrieve"] = sql or ""
    if sql:
        d["sql"] = analyze_sql(sql, sql.lstrip().upper().startswith("PBSELECT"))
    else:
        d["sql"] = None

    # ---- update (updatable DW)
    um = re.search(r"(?m)^\s*update\s*=\s*\"", raw)
    d["updatable"] = 1 if um else 0
    if um:
        uval, _, _ = extract_assignment(raw[um.start():], "update=")
        d["update_table"] = (uval or "").strip()

    # ---- retrieve.asneeded / rows / buffer / sort / filter
    d["retrieve_asneeded"] = 1 if re.search(r"retrieve\.asneeded\s*=\s*yes", raw, re.I) else 0
    rm = re.search(r"(?m)^\s*rows\s*=\s*(\d+)", raw, re.I)
    d["rows_setting"] = int(rm.group(1)) if rm else None
    bm = re.search(r"(?m)^\s*buffer\s*=\s*(\d+)", raw, re.I)
    d["buffer_setting"] = int(bm.group(1)) if bm else None
    sm = re.search(r"(?m)^\s*sort\s*=\s*\"", raw)
    d["sort"] = ""
    if sm:
        sv, _, _ = extract_assignment(raw[sm.start():], "sort=")
        d["sort"] = sv or ""
    fm = re.search(r"(?m)^\s*filter\s*=\s*\"", raw)
    d["filter"] = ""
    if fm:
        fv, _, _ = extract_assignment(raw[fm.start():], "filter=")
        d["filter"] = fv or ""

    # ---- arguments
    d["arguments"] = []
    am = re.search(r"(?m)^\s*arguments\s*=\s*\(", raw)
    if am:
        inner, _ = balanced(raw, raw.index("(", am.start()))
        for m in re.finditer(r'\(\s*"([^"]+)"\s*,\s*([\w]+)', inner):
            d["arguments"].append({"name": m.group(1), "type": m.group(2).lower()})
    d["n_args"] = len(d["arguments"])

    # ---- table( columns )
    d["n_columns"] = 0
    d["columns"] = []
    tm = re.search(r"(?m)^\s*table\s*\(", raw)
    if tm:
        tbl_inner, _ = balanced(raw, raw.index("(", tm.start()))
        # stop at retrieve/update if balanced swallowed something odd
        pos = 0
        while True:
            cm = re.search(r"column\s*=\s*\(", tbl_inner[pos:])
            if not cm:
                break
            cs = pos + cm.end() - 1
            cinner, cend = balanced(tbl_inner, cs)
            a = attrs(cinner)
            d["columns"].append({
                "name": a.get("name", ""),
                "type": a.get("type", ""),
                "dbname": a.get("dbname", ""),
                "key": a.get("key", ""),
                "update": a.get("update", ""),
                "updatewhereclause": a.get("updatewhereclause", ""),
                "width": a.get("width", ""),
                "initial": a.get("initial", ""),
                "validation": (a.get("validation", "") or "")[:200],
            })
            pos = cend + 1
        d["n_columns"] = len(d["columns"])
        d["n_key_cols"] = sum(1 for c in d["columns"] if c["key"].lower() == "yes")
        d["n_update_cols"] = sum(1 for c in d["columns"] if c["update"].lower() == "yes")
        d["n_where_cols"] = sum(1 for c in d["columns"] if c["updatewhereclause"].lower() == "yes")
        d["char_cols"] = sum(1 for c in d["columns"] if c["type"].lower().startswith("char"))
        d["wide_cols"] = sum(1 for c in d["columns"] if re.match(r"char\((\d+)\)", c["type"], re.I) and int(re.match(r"char\((\d+)\)", c["type"], re.I).group(1)) >= 100)
        d["blob_cols"] = sum(1 for c in d["columns"] if "blob" in c["type"].lower() or "binary" in c["type"].lower())
        d["dec_cols"] = sum(1 for c in d["columns"] if c["type"].lower().startswith("decimal"))

    # ---- presentation inventory
    d["n_compute"] = len(re.findall(r"(?m)^\s*compute\s*\(", raw))
    d["n_text"] = len(re.findall(r"(?m)^\s*text\s*\(", raw))
    d["n_column_objs"] = len(re.findall(r"(?m)^\s*column\s*\(", raw))
    d["n_groups"] = len(re.findall(r"(?m)^\s*group\s*\(", raw))
    d["n_graph"] = len(re.findall(r"(?m)^\s*graph\s*\(", raw))
    d["n_crosstab"] = len(re.findall(r"(?m)^\s*crosstab\s*\(", raw))
    d["n_nested"] = len(re.findall(r"(?m)^\s*report\s*\(", raw))
    d["nested_refs"] = re.findall(r'dataobject\s*=\s*"([^"]+)"', raw)
    d["n_line"] = len(re.findall(r"(?m)^\s*line\s*\(", raw))
    d["n_rect"] = len(re.findall(r"(?m)^\s*rectangle\s*\(", raw))
    d["n_groupbox"] = len(re.findall(r"(?m)^\s*groupbox\s*\(", raw))
    d["n_picture"] = len(re.findall(r"(?m)^\s*picture\s*\(", raw))
    d["n_button"] = len(re.findall(r"(?m)^\s*button\s*\(", raw))
    # group by fields
    d["group_by_fields"] = []
    for gm in re.finditer(r"(?m)^\s*group\s*\(([^\n]*)\)", raw):
        bm2 = re.search(r'\bby\s*=\s*\(\s*"([^"]*)"', gm.group(1))
        if bm2:
            d["group_by_fields"].append(bm2.group(1))
    # summary band height
    shm = re.search(r"summary\s*\(height\s*=\s*(\d+)", raw, re.I)
    d["summary_height"] = int(shm.group(1)) if shm else 0
    dhm = re.search(r"detail\s*\(height\s*=\s*(\d+)", raw, re.I)
    d["detail_height"] = int(dhm.group(1)) if dhm else 0

    # sort/filter shape
    d["sort_keys"] = len([x for x in re.split(r",", d["sort"]) if x.strip()]) if d["sort"] else 0
    d["sort_on_compute"] = 1 if re.search(r"\b(c_|compute)", d["sort"], re.I) else 0
    d["filter_len"] = len(d["filter"])
    d["filter_has_like"] = 1 if re.search(r"\bLIKE\b", d["filter"], re.I) else 0
    d["filter_has_or"] = 1 if re.search(r"\bOR\b", d["filter"], re.I) else 0

    # ---- classification
    sqlm = d["sql"]
    d["is_composite"] = 1 if (not d["has_retrieve"] and d["n_nested"] > 0) else 0
    d["is_crosstab"] = 1 if d["n_crosstab"] else 0
    d["is_graph"] = 1 if d["n_graph"] else 0
    upd = d["updatable"] == 1
    reportish = (d["is_composite"] or d["n_groups"] > 0 or d["retrieve_asneeded"] or
                 d["n_crosstab"] or d["n_graph"] or d["summary_height"] > 0 or
                 lib_hint(lib) == "report")
    d["kind"] = "entry" if upd and not reportish else ("composite" if d["is_composite"] else ("report" if reportish else "list"))
    d["rpt_flag"] = 1 if reportish else 0

    # retention/memory proxy: result width
    d["result_width"] = sum(type_width(c["type"]) for c in d["columns"]) if d["columns"] else 0

    # heavy score filled later
    return d


def lib_hint(lib):
    l = lib.lower()
    if any(k in l for k in ("report", "sprnt", "printout", "print", "billsummary", "aging", "dashboard")):
        return "report"
    return ""


def type_width(t):
    t = t.lower().strip()
    m = re.match(r"(char|varchar|nchar|nvarchar)\s*\(\s*(\d+)", t)
    if m:
        return int(m.group(2))
    if t.startswith("decimal"):
        m = re.match(r"decimal\s*\(\s*(\d+)", t)
        return 9 if not m else min(17, max(4, int(m.group(1)) // 2 + 2))
    return {"long": 4, "ulong": 4, "int": 2, "uint": 2, "smallint": 2,
            "datetime": 8, "date": 4, "time": 4, "double": 8, "real": 4,
            "boolean": 1, "byte": 1}.get(t, 8)


# ---------------- usage cross reference ----------------
def scan_scripts():
    use = defaultdict(lambda: {"scripts": set(), "refs": 0, "libs": set(), "retrieves": 0})
    pat = re.compile(r'\.?\bdataobject\s*=\s*"([^"]+)"', re.I)
    retr_pat = re.compile(r"\.retrieve\s*\(", re.I)
    files = 0
    for p in SCRIPTROOT.rglob("*.pbs"):
        files += 1
        txt = p.read_text(encoding="latin-1", errors="replace")
        lib = p.relative_to(SCRIPTROOT).parts[0]
        for mm in pat.finditer(txt):
            nm = mm.group(1).strip().lower()
            if not nm:
                continue
            u = use[nm]
            u["scripts"].add(str(p))
            u["refs"] += 1
            u["libs"].add(lib)
        if retr_pat.search(txt):
            # attribute retrieve calls to every dataobject literal in the file (upper bound)
            for nm in set(x.group(1).lower() for x in pat.finditer(txt)):
                use[nm]["retrieves"] += 1
    return files, use


def main():
    files = sorted(DWROOT.rglob("*.srd"))
    rows = []
    errs = 0
    for i, p in enumerate(files):
        try:
            rows.append(parse_dw(p))
        except Exception as e:  # noqa
            errs += 1
            rows.append({"lib": p.relative_to(DWROOT).parts[0], "name": p.stem,
                         "path": str(p.relative_to(DWROOT)).replace("\\", "/"),
                         "bytes": p.stat().st_size, "parse_error": repr(e)})
        if (i + 1) % 1000 == 0:
            print(f"parsed {i+1}/{len(files)}", file=sys.stderr)

    nscripts, use = scan_scripts()
    # normalise DW keys: name only (DataWindows are referenced by object name)
    for r in rows:
        k = r["name"].lower()
        u = use.get(k)
        r["used_by_scripts"] = len(u["scripts"]) if u else 0
        r["used_by_libs"] = len(u["libs"]) if u else 0
        r["ref_count"] = u["refs"] if u else 0
        r["script_libs"] = sorted(u["libs"])[:8] if u else []

    # nested ref counts also count as usage
    nested_counts = Counter()
    for r in rows:
        for nr in r.get("nested_refs", []):
            nested_counts[nr.lower()] += 1
    for r in rows:
        r["nested_used_by"] = nested_counts.get(r["name"].lower(), 0)
        r["usage_score"] = r["used_by_scripts"] + 2 * r["nested_used_by"]

    # ---- scoring
    for r in rows:
        s = r.get("sql")
        score = 0.0
        if s:
            score += min(40, s["n_tables"] * 5 + s["n_joins"] * 4)
            score += min(30, s["subqueries"] * 6 + s["union"] * 4 + s["scalar_subquery"] * 5)
            score += min(20, s["func_on_col"] * 2 + s["case_count"] * 1.5 + s["isnull"] * 2)
            score += 8 if s["select_star"] else 0
            score += 6 if s["distinct"] else 0
            score += 8 if s["order_by"] else 0
            score += 10 if s["group_by"] else 0
            score += 10 if s["having"] else 0
            score += 12 if s["like_prefix"] else 0
            score += min(15, s["where_has_or"] * 3)
            score += 10 if s["not_in"] else 0
            score += 6 if s["temp_table"] else 0
            score += 10 if s["cross_join"] else 0
            score += min(12, s["where_func_col"] * 3)
        score += min(30, r.get("n_columns", 0) * 0.15)
        score += min(20, r.get("n_compute", 0) * 0.8)
        score += 10 if r.get("n_nested", 0) else 0
        score += min(20, r.get("size_kb", r["bytes"] / 1024) * 0.06)
        score += min(25, r.get("used_by_scripts", 0) * 1.2)
        r["heavy_score"] = round(score, 1)

    # outputs
    with open(OUT / "dw_metrics.json", "w", encoding="utf-8") as f:
        json.dump(rows, f, indent=1)
    import csv
    cols = ["lib", "name", "path", "bytes", "kind", "updatable", "retrieve_asneeded",
            "rows_setting", "buffer_setting", "sort", "filter", "n_args", "n_columns",
            "n_key_cols", "n_where_cols", "wide_cols", "n_compute", "n_groups", "n_nested",
            "summary_height", "used_by_scripts", "nested_used_by", "heavy_score",
            "n_tables", "n_joins", "subqueries", "union", "select_star", "distinct",
            "top", "order_by", "group_by", "having", "like_prefix", "or_count",
            "not_in", "exists", "case_count", "func_on_col", "isnull", "convert",
            "temp_table", "sql_len"]
    with open(OUT / "dw_metrics.csv", "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(cols)
        for r in rows:
            s = r.get("sql") or {}
            w.writerow([r.get("lib"), r.get("name"), r.get("path"), r.get("bytes"),
                        r.get("kind"), r.get("updatable"), r.get("retrieve_asneeded"),
                        r.get("rows_setting"), r.get("buffer_setting"), r.get("sort"),
                        r.get("filter"), r.get("n_args"), r.get("n_columns"),
                        r.get("n_key_cols"), r.get("n_where_cols"), r.get("wide_cols"),
                        r.get("n_compute"), r.get("n_groups"), r.get("n_nested"),
                        r.get("summary_height"), r.get("used_by_scripts"),
                        r.get("nested_used_by"), r.get("heavy_score"),
                        s.get("n_tables"), s.get("n_joins"), s.get("subqueries"),
                        s.get("union"), s.get("select_star"), s.get("distinct"),
                        s.get("top"), s.get("order_by"), s.get("group_by"),
                        s.get("having"), s.get("like_prefix"), s.get("or_count"),
                        s.get("not_in"), s.get("exists"), s.get("case_count"),
                        s.get("func_on_col"), s.get("isnull"), s.get("convert"),
                        s.get("temp_table"), s.get("sql_len")])
    print(f"parsed={len(rows)} errors={errs} scripts={nscripts} "
          f"dws_with_usage={sum(1 for r in rows if r['used_by_scripts'])}", file=sys.stderr)


if __name__ == "__main__":
    main()
