
#variable_conflict use_column
DECLARE
  v_qry citext;
  v_colname citext;
  v_tbl citext;
  v_pk citext;
  v_fulltbl citext;
  v_keyseq smallint;
  v_table_id integer;
  v_err integer;
  cur_upd1 refcursor;
  cur_upd2 refcursor;
  _dq1 text;
  _fs integer := -1;
BEGIN
  -- SET NOCOUNT ON
  -- SET ANSI_NULLS ON
  -- SET ANSI_WARNINGS ON
  OPEN cur_upd1 FOR SELECT ltrim(rtrim(tabname)) AS tablename FROM dbo._tabmaxkey WHERE ((tabid <> 12) AND (tabname NOT IN ('Quotation', 'SaleLedgerCashDummy', 'SaleLedgerCreditDummy', 'DataTransferLog', 'PrescriptionHeaderLog', 'SRLedger'))) UNION ALL SELECT 'SaleLedger' AS tablename ORDER BY 1;
  FETCH NEXT FROM cur_upd1 INTO v_tbl;
  IF FOUND THEN _fs := 0; ELSE _fs := -1; END IF;
  WHILE (_fs = 0) LOOP
    v_pk := '';
    v_fulltbl := ('DBO.' || v_tbl);
    -- SET @table_id = OBJECT_ID(@FullTBL)
    RAISE EXCEPTION 'untranslated T-SQL (OBJECT_ID of non-literal)' USING ERRCODE = '0A000';
    v_err := 0;
    IF (((0 <> 0) OR (v_err <> 0)) OR (v_table_id IS NULL)) THEN
      RAISE EXCEPTION 'TabMaxKey Initialization: Invalid Object Refered: Name = %', v_fulltbl;
      CLOSE cur_upd1;
      -- DEALLOCATE Upd1
      return_value := -1;
      RETURN;
    END IF;
    -- OPEN Upd2
    RAISE EXCEPTION 'untranslated T-SQL (system table sysindexes)' USING ERRCODE = '0A000';
    FETCH NEXT FROM cur_upd2 INTO v_colname, v_keyseq;
    IF FOUND THEN _fs := 0; ELSE _fs := -1; END IF;
    WHILE (_fs = 0) LOOP
      IF (v_keyseq <> 1) THEN
        v_pk := (v_pk || ' AND ');
      END IF;
      v_pk := ((v_pk || ' ') || ltrim(rtrim(v_colname)));
      FETCH NEXT FROM cur_upd2 INTO v_colname, v_keyseq;
      IF FOUND THEN _fs := 0; ELSE _fs := -1; END IF;
    END LOOP;
    CLOSE cur_upd2;
    -- DEALLOCATE Upd2
    v_qry := (((((('UPDATE _TabMaxKey SET Tabmaxkey = COALESCE((SELECT MAX(' || v_pk) || ') FROM ') || v_tbl) || '), 0) WHERE Tabname = ''') || v_tbl) || '''');
    _dq1 := v_qry;
    IF _dq1 IS NOT NULL THEN
      EXECUTE dbo.tsql_dyn(_dq1);
    END IF;
    v_err := 0;
    IF ((0 <> 0) OR (v_err <> 0)) THEN
      RAISE EXCEPTION 'TabMaxKey Initialization: Problem In Updation of % Table', v_fulltbl;
      CLOSE cur_upd1;
      -- DEALLOCATE Upd1
      return_value := -1;
      RETURN;
    END IF;
    FETCH NEXT FROM cur_upd1 INTO v_tbl;
    IF FOUND THEN _fs := 0; ELSE _fs := -1; END IF;
  END LOOP;
  CLOSE cur_upd1;
  -- DEALLOCATE Upd1
  UPDATE dbo._tabmaxkey SET tabmaxkey = coalesce((SELECT max(transferlogid) FROM dbo.datatransferlog), 0) WHERE (tabname = 'DataTransferLog');
  UPDATE dbo._tabmaxkey SET tabmaxkey = coalesce((SELECT max(logid) FROM dbo.prescriptionheaderlog), 0) WHERE (tabname = 'PrescriptionHeaderLog');
  UPDATE dbo._tabmaxkey SET tabmaxkey = coalesce((SELECT max(a) FROM (SELECT coalesce(max(srinvcode), 0) AS a FROM dbo.srledger UNION SELECT coalesce(max(srbufferinvcode), 0) AS a FROM dbo.srbufferledger) AS t), 0) WHERE (tabname = 'SRLedger');
  UPDATE dbo._tabmaxkey SET tabmaxkey = coalesce((SELECT max(quotationcode) FROM dbo.quotationheader), 0) WHERE (tabname = 'Quotation');
  UPDATE dbo._tabmaxkey SET tabmaxkey = 0 WHERE (tabname IN ('SaleLedgerCashDummy', 'SaleLedgerCreditDummy'));
  UPDATE dbo._tabmaxkey SET tabmaxkey = 0 WHERE ((tabid = 12) AND (tabname <> 'SaleLedger'));
  UPDATE dbo.vochercategory SET counter = coalesce((SELECT max(glheader.vouchercode) FROM dbo.glheader WHERE (glheader.vochcatcode = vochercategory.vochcatcode)), 0);
  UPDATE dbo.notescategory SET counter = coalesce((SELECT max(notes.vouchercode) FROM dbo.notes WHERE (notes.notecatcode = notescategory.notecatcode)), 0);
  UPDATE dbo.saletype SET counter = coalesce((SELECT max(coalesce(saleledger.saletypeinvno, 0)) FROM dbo.saleledger WHERE (saleledger.saletypecode = saletype.saletypecode)), 0);
  UPDATE dbo.saleordercategory SET counter = coalesce((SELECT max(coalesce(saleorderheader.saleordercode, 0)) FROM dbo.saleorderheader WHERE (saleorderheader.socatcode = saleordercategory.socatcode)), 0);
  UPDATE dbo.receiptcategory SET counter = coalesce((SELECT max(coalesce(receiptheader.receiptcode, 0)) FROM dbo.receiptheader WHERE (receiptheader.receiptcategorycode = receiptcategory.receiptcategorycode)), 0);
  UPDATE dbo.issuecategory SET counter = coalesce((SELECT max(coalesce(issueheader.issuecode, 0)) FROM dbo.issueheader WHERE (issueheader.issuecategorycode = issuecategory.issuecategorycode)), 0);
  UPDATE dbo._tabmaxkey SET tabmaxkey = 100 WHERE ((tabname = 'Accounts') AND (coalesce((SELECT max(coalesce(acccode, 0)) FROM dbo.accounts), 0) < 100));
  UPDATE dbo._tabmaxkey SET tabmaxkey = 100 WHERE ((tabname = 'SubAccounts') AND (coalesce((SELECT max(coalesce(subacccode, 0)) FROM dbo.subaccounts), 0) < 100));
  UPDATE dbo._tabmaxkey SET tabmaxkey = 100 WHERE ((tabname = 'CategoryAccounts') AND (coalesce((SELECT max(coalesce(catacccode, 0)) FROM dbo.categoryaccounts), 0) < 100));
  UPDATE dbo._tabmaxkey SET tabmaxkey = 100 WHERE ((tabname = 'VocherCategory') AND (coalesce((SELECT max(coalesce(vochcatcode, 0)) FROM dbo.vochercategory), 0) < 100));
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.saleledger AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 1);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.srledger AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 2);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.purledger AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 3);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.prledger AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 4);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.issueheader AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 5);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.receiptheader AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 6);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.adjheader AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 7);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.theader AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 8);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.saleorderheader AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 12);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = 0 WHERE (module = 15);
  UPDATE dbo._headertabmaxkey SET tabmaxkey = coalesce((SELECT max(coalesce(s.headerinvno, 0)) FROM dbo.advsaleledger AS s WHERE (s.headerno = _headertabmaxkey.headercode)), 0) WHERE (module = 21);
  return_value := 0;
  RETURN;
  return_value := 0;
  RETURN;
END

