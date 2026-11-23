-- Performance indexes found while fixing repeated full item-list retrieves.
--
-- The shared item list (ddd_itemmanfnames_groupgodown / _popup) computes three stock columns for every item:
--   stock  = sum(godowndetail.currqty) WHERE icode = item.icode
--   sstock = sum(godowndetail.currqty) WHERE icode = item.icode AND gcode IN (<allowed sale godowns>)
--   pstock = sum(godowndetail.currqty) WHERE icode = item.icode AND gcode IN (<allowed purchase godowns>)
-- The only matching index was i_gdits(gcode, icode), whose leading column is gcode, so PostgreSQL read the table
-- once per item (534,611 shared buffers for 27,818 items).  This index leads with icode and covers currqty, turning
-- those reads into index-only scans without changing the query text or its result rows.
CREATE INDEX IF NOT EXISTS ix_godowndetail_icode_gcode_qty
  ON dbo.godowndetail (icode, gcode) INCLUDE (currqty);

ANALYZE dbo.godowndetail;
