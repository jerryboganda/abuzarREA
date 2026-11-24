"""Source-level fixes applied on top of the faithful regeneration (read by re-tools/pbsrc_export.py, third argument).

PATCHES = [(object, extension, description, regex, replacement, expected number of matches)]
Every patch must match exactly as often as expected, or the generator lists it under `patches_failed`.

Origin of each group is noted with it.  The 2026-11-23 groups repeat, in source, the fixes that were patched into the
compiled libraries of deploy\\Application that day (deploy/FIX-LOG-2026-11-23.md).
"""

PATCHES = []

# --- 2026-11-23, report argument windows: empty grouping parameter -------------------------------------------------------
# The first dialog (Manufacturer / Category / Class / Packing) can be cancelled; the window then opened with an empty
# parameter, no branch of the chain ran, and the list was unusable ("Not a DataWindowChild").  Any value that is not one
# of the other branches now takes the Manufacturer branch.
_MCLP = """w_arg_classes_godowns w_arg_group_allowedgodowns_zqty w_arg_group_allowedgodowns_zqty_ptype w_arg_grouping
w_arg_grouping_area_period w_arg_grouping_area_period_top w_arg_grouping_ccat_area w_arg_grouping_dates
w_arg_grouping_dates_cashcredit w_arg_grouping_dates_cashcredit_batch w_arg_grouping_dates_price
w_arg_grouping_dates_pricetype w_arg_grouping_dates_pricetype2 w_arg_grouping_dates_pricetype3
w_arg_grouping_dates_pricetype4 w_arg_grouping_dates_pricetype_batch w_arg_grouping_dates_pricetype_old
w_arg_grouping_dates_pricetype_zone w_arg_grouping_dates_zoneothers_price w_arg_grouping_godowngroup
w_arg_grouping_godowns w_arg_grouping_godowns_allowed w_arg_grouping_godowns_period
w_arg_grouping_godowns_zeroqty_pricetype w_arg_grouping_price w_arg_grouping_price_batch w_arg_grouping_pricetype2
w_arg_grouping_region_include_bns_ret w_arg_grouping_sperson_period_top w_arg_grouping_stockandsale
w_arg_grouping_zeroqty_pricetype w_arg_manf_cat_class_pack w_arg_manf_cat_class_pack_sdate_ldate
w_arg_manf_cat_class_pack_single w_arg_manfs_cats_classes_packs w_arg_manfs_cats_classes_packs_area
w_arg_manfs_cats_classes_packs_ccat_area w_arg_manfs_cats_classes_packs_custcats
w_arg_manfs_cats_classes_packs_dates w_arg_manfs_cats_classes_packs_dates_v2
w_arg_manfs_cats_classes_packs_dates_v3 w_arg_manfs_cats_classes_packs_days w_arg_manfs_cats_classes_packs_godowns
w_arg_manfs_cats_classes_packs_godowns2 w_arg_manfs_cats_classes_packs_itemgroup
w_arg_manfs_cats_classes_packs_manfs w_arg_manfs_cats_classes_packs_price w_arg_manfs_cats_classes_packs_price_v2
w_arg_manfs_cats_classes_packs_region w_arg_manfs_cats_classes_packs_region2 w_arg_manfs_cats_classes_packs_region3
w_arg_manfs_cats_classes_packs_regions w_arg_manfs_cats_classes_packs_subarea
w_arg_manfs_cats_classes_packs_subarea2 w_arg_manfs_cats_classes_packs_v2 w_arg_manfs_cats_classes_packs_zones
w_arg_manfs_custgroup_godowns_period w_arg_manfs_custs_date w_arg_manfs_custs_disc_perc_sdate_ldate
w_arg_manfs_custs_godowns_sdate_ldate w_arg_manfs_custs_godowns_sdate_ldate2 w_arg_manfs_custs_sdate_ldate
w_arg_manfs_godowns w_arg_manfs_godowns2 w_arg_manfs_salesman_godowns_sdate_ldate w_arg_manfs_salesman_sdate_ldate
w_arg_manfs_supps_sdate_ldate w_arg_salesman_grouping_sdate_ldate_rate w_arg_zone_grouping_sdate_ldate_rate
w_arg_zone_grouping_sdate_ldate_rate_v2""".split()

_HEAD = r'(?m)^(\s*)if this\.is_stringparam = "M" then[ \t]*(\r?)$'
_WHAT = 'empty grouping parameter opens the Manufacturer list (2026-11-23)'
for _w in _MCLP:
    PATCHES.append((_w, 'srw', _WHAT, _HEAD,
                    r'\1if isnull(this.is_stringparam) or (this.is_stringparam <> "C" and this.is_stringparam <> "L" '
                    r'and this.is_stringparam <> "P") then\2', 1))
# --- 2026-11-23, report viewer: format box closed with X ------------------------------------------------------------------
# A format box closed without a choice leaves a format number that no branch of the chain handles; no argument window is
# opened, and the next statement (`as_reparg = message.powerobjectparm`) stopped the program with "Null object reference".
# The 19 chains found by the menu walk get an `else` that leaves the report unretrieved (the binary patch sent them to the
# end of their case; what follows there is the function's `return 1`).
# (function, variable, last format of the chain, which occurrence of that `elseif` line (0-based), occurrences in all)
_RV = [('f_retrieve_report3', 'al_format', 2, 0, 14), ('f_retrieve_report3', 'al_format', 4, 2, 9),
       ('f_retrieve_report3', 'al_format', 4, 3, 9), ('f_retrieve_report3', 'li_format', 3, 0, 1),
       ('f_retrieve_report3', 'al_format', 4, 7, 9), ('f_retrieve_report4', 'al_format', 2, 2, 12),
       ('f_retrieve_report5', 'al_format', 7, 0, 7), ('f_retrieve_report5', 'al_format', 4, 2, 16),
       ('f_retrieve_report5', 'al_format', 4, 10, 16), ('f_retrieve_report6', 'al_format', 2, 3, 21),
       ('f_retrieve_report6', 'al_format', 5, 1, 5), ('f_retrieve_report7', 'al_format', 3, 0, 11),
       ('f_retrieve_report7', 'al_format', 6, 3, 4), ('f_retrieve_report8', 'al_format', 3, 3, 11),
       ('f_retrieve_report8', 'al_format', 3, 4, 11), ('f_retrieve_report8', 'al_format', 18, 0, 1),
       ('f_retrieve_report8', 'al_format', 12, 1, 2), ('f_retrieve_report9', 'al_format', 3, 12, 17),
       ('f_retrieve_report9', 'al_format', 6, 3, 5)]
# the summarised account ledger rolls back before it leaves (its case does so when no arguments were given)
_RV_ROLLBACK = {('f_retrieve_report5', 'al_format', 4, 10)}


def _closed_boxes(fn):
    """adds the `else` to the listed chains of one function.  A chain is named by the line it ends with and by which
    occurrence of that line it is; if the number of such lines is not the one recorded, nothing is done for that chain
    (the patch then counts as failed: the function changed and the list must be looked at again)"""
    sites = [s for s in _RV if s[0] == fn]

    def apply(text):
        nl = '\r\n' if '\r\n' in text else '\n'
        lines = text.split(nl)
        inserts = []
        for _, var, n, which, total in sites:
            idx = [i for i, x in enumerate(lines) if x.strip() == 'elseif %s = %d then' % (var, n)]
            if len(idx) != total:
                continue
            i = idx[which]
            ind = lines[i][:len(lines[i]) - len(lines[i].lstrip())]
            j = i + 1
            while j < len(lines) and (not lines[j].strip() or (lines[j].startswith(ind) and lines[j][len(ind):len(ind) + 1] in ('\t', ' '))):
                j += 1
            if j < len(lines) and lines[j] == ind + 'end if':            # the chain has no `else` of its own
                new = [ind + 'else']
                if (fn, var, n, which) in _RV_ROLLBACK:
                    new.append(ind + '\tROLLBACK USING sqlca;')
                inserts.append((j, new + [ind + '\treturn 1']))
        for j, new in sorted(inserts, reverse=True):                     # bottom up: the positions above stay valid
            lines[j:j] = new
        return nl.join(lines), len(inserts)
    return apply


for _fn in sorted({s[0] for s in _RV}):
    PATCHES.append((_fn, 'srf', 'format box closed with X no longer stops the program (2026-11-23)', None, _closed_boxes(_fn),
                    sum(1 for s in _RV if s[0] == _fn)))

# Stock in Hand - Audit Purpose, Format 2: the argument window can be cancelled; retrieve only when it was confirmed
PATCHES.append(('f_retrieve_report9', 'srf', 'audit stock report format 2: no retrieve after Cancel (2026-11-23)',
                r'(?m)^([ \t]*)(adw_report\.dataobject = "d_manf_cat_class_pack_auditstockinhand_2"[ \t]*\r?\n'
                r'[ \t]*open\(w_arg_manufacturercategory\)[ \t]*\r?\n[ \t]*as_reparg = message\.powerobjectparm[ \t]*\r?\n'
                r'[ \t]*adw_report\.settransobject\(sqlca\)[ \t]*(\r?\n))[ \t]*'
                r'(i_rtcode = adw_report\.retrieve\(as_reparg\.ia_integerlist\))[ \t]*(?=\r?$)',
                r'\1\2\1if as_reparg.i_status = 1 then\3\1\t\4\3\1end if', 1))

# --- regression aid: abuzar.exe /selftest opens every window named in selftest.list (improve/objects/.../w_selftest.srw) ---
# Without the switch nothing changes.  The window itself refuses to run unless the database name contains "test".
PATCHES.append(('traderappv1', 'sra', 'start the self test when asked for on the command line',
                r'(?m)^(af_launch_dashboard\(\))[ \t]*(\r?\n)',
                r'\1\2if pos(lower(commandline), "/selftest") > 0 then\2\topen(w_selftest)\2end if\2', 1))

# --- run-time errors are written to a log (roadmap I4) ------------------------------------------------------------------
# Without a systemerror script PowerBuilder shows "Application terminated" and stops.  The script keeps that for users
# (same box, then halt) and first appends the error to errors.log in the program folder.  During the self test the
# error is handed to the test window instead, which goes on with the next window.
PATCHES.append(('traderappv1', 'sra', 'systemerror: log run-time errors; the self test continues after one',
                r'(?m)^(event close;)',
                'event systemerror;string ls_text\r\n'
                'integer li_file\r\n'
                'ls_text = "Error: " + error.text + " at line " + string(error.line) + " in " + error.objectevent '
                '+ " event of object " + error.object + "."\r\n'
                'li_file = fileopen("errors.log", linemode!, write!, lockwrite!, append!)\r\n'
                'if li_file > 0 then\r\n'
                '\tfilewrite(li_file, string(today(), "yyyy-mm-dd") + " " + string(now(), "hh:mm:ss") + " " + gs_localcomputername '
                '+ " user " + string(gl_usercode) + " | (R" + string(error.number, "0000") + ") " + ls_text)\r\n'
                '\tfileclose(li_file)\r\n'
                'end if\r\n'
                'if isvalid(w_selftest) then\r\n'
                '\tw_selftest.wf_error(ls_text)\r\n'
                '\treturn\r\n'
                'end if\r\n'
                'messagebox("PowerBuilder application execution error (R" + string(error.number, "0000") + ")", '
                '"Application terminated.~r~n~r~n" + ls_text, stopsign!)\r\n'
                'halt\r\n'
                'end event\r\n\r\n\\1', 1))

# this one has no Packing branch
PATCHES.append(('w_arg_stockinbackdate', 'srw', _WHAT, _HEAD,
                r'\1if isnull(this.is_stringparam) or (this.is_stringparam <> "C" and this.is_stringparam <> "L") then\2', 1))
