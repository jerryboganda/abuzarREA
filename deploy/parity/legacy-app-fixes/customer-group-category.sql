-- Allow every legacy group to see customers in the only configured customer
-- category (DEFAULT CATEGORY, CustCatCode 1).
--
-- CustomerGroupCategory was empty.  The "Claimable for Allowed Customers" and
-- "Customer NTN Wise Sales Tax Report" selection lists filter customers through
-- this table; with no rows they returned an empty Selection List and the report
-- could not start.  The two report DataWindows themselves are fine (verified
-- with 2025-01-01 data).
USE FazalDinPP19DataBaseV2;
GO
SET NOCOUNT ON;

INSERT INTO dbo.CustomerGroupCategory (GroupCode, CustomerCategoryCode, Status)
SELECT g.GroupCode, 1, 1
FROM dbo.Groups AS g
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.CustomerGroupCategory AS c
    WHERE c.GroupCode = g.GroupCode
      AND c.CustomerCategoryCode = 1
);

SELECT GroupCode, CustomerCategoryCode, Status
FROM dbo.CustomerGroupCategory
ORDER BY GroupCode;
GO
