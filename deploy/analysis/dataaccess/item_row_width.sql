SET NOCOUNT ON;
SELECT COUNT(*) AS active_items FROM dbo.Item WHERE Active = 1;
SELECT
  AVG(DATALENGTH(customicode)) AS customicode_b,
  AVG(DATALENGTH(name)) AS name_b,
  AVG(DATALENGTH(localitemname)) AS localitemname_b,
  AVG(DATALENGTH(packingdesc)) AS packingdesc_b,
  AVG(DATALENGTH(location)) AS location_b,
  AVG(DATALENGTH(remarks)) AS remarks_b,
  AVG(4 + 4 + 4 + 8 + 8 + 8 + 8 + 8 + 8 + 8 + 4 + 4 + 4 + 4 + 4 + 4 + 8) AS numeric_b
FROM dbo.Item WHERE Active = 1;
SELECT AVG(DATALENGTH(name)) AS manf_name_b FROM dbo.Manufacturer;
SELECT AVG(DATALENGTH(name)) AS packing_name_b FROM dbo.ItemPacking;
SELECT AVG(DATALENGTH(name)) AS generic_name_b FROM dbo.GenericItem;
