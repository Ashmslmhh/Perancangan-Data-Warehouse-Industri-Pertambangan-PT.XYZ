-- PT XYZ Data Warehouse Validation Script
-- Automated Validation

USE PTXYZ_DataWarehouse;
GO


PRINT '================================';
PRINT '1. SCHEMA VALIDATION';
PRINT '================================';


SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA IN ('dim','fact','staging')
ORDER BY TABLE_SCHEMA, TABLE_NAME;
GO



PRINT '================================';
PRINT '2. ROW COUNT VALIDATION';
PRINT '================================';


SELECT 'DimTime' AS TableName, COUNT(*) AS Total FROM dim.DimTime
UNION ALL
SELECT 'DimSite', COUNT(*) FROM dim.DimSite
UNION ALL
SELECT 'DimEquipment', COUNT(*) FROM dim.DimEquipment
UNION ALL
SELECT 'DimMaterial', COUNT(*) FROM dim.DimMaterial
UNION ALL
SELECT 'DimEmployee', COUNT(*) FROM dim.DimEmployee
UNION ALL
SELECT 'DimShift', COUNT(*) FROM dim.DimShift
UNION ALL
SELECT 'DimProject', COUNT(*) FROM dim.DimProject
UNION ALL
SELECT 'DimAccount', COUNT(*) FROM dim.DimAccount
UNION ALL
SELECT 'FactEquipmentUsage', COUNT(*) FROM fact.FactEquipmentUsage
UNION ALL
SELECT 'FactProduction', COUNT(*) FROM fact.FactProduction
UNION ALL
SELECT 'FactFinancialTransaction', COUNT(*) FROM fact.FactFinancialTransaction;
GO



PRINT '================================';
PRINT '3. FOREIGN KEY ORPHAN CHECK';
PRINT 'Target: 0';
PRINT '================================';


-- Equipment Usage

SELECT 
'FactEquipmentUsage_time' AS CheckName,
COUNT(*) AS OrphanCount
FROM fact.FactEquipmentUsage f
LEFT JOIN dim.DimTime d
ON f.time_key=d.time_key
WHERE d.time_key IS NULL;


SELECT 
'FactEquipmentUsage_site' AS CheckName,
COUNT(*) AS OrphanCount
FROM fact.FactEquipmentUsage f
LEFT JOIN dim.DimSite d
ON f.site_key=d.site_key
WHERE d.site_key IS NULL;


SELECT 
'FactEquipmentUsage_equipment' AS CheckName,
COUNT(*) AS OrphanCount
FROM fact.FactEquipmentUsage f
LEFT JOIN dim.DimEquipment d
ON f.equipment_key=d.equipment_key
WHERE d.equipment_key IS NULL;


-- Production

SELECT 
'FactProduction_time' AS CheckName,
COUNT(*) AS OrphanCount
FROM fact.FactProduction f
LEFT JOIN dim.DimTime d
ON f.time_key=d.time_key
WHERE d.time_key IS NULL;


-- Financial

SELECT 
'FactFinancial_account' AS CheckName,
COUNT(*) AS OrphanCount
FROM fact.FactFinancialTransaction f
LEFT JOIN dim.DimAccount d
ON f.account_key=d.account_key
WHERE d.account_key IS NULL;

GO



PRINT '================================';
PRINT '4. DUPLICATE CHECK';
PRINT '================================';


SELECT 
'usage_key_duplicate' AS CheckName,
COUNT(*) AS DuplicateCount
FROM
(
SELECT usage_key, COUNT(*) jumlah
FROM fact.FactEquipmentUsage
GROUP BY usage_key
HAVING COUNT(*) > 1
) x;


SELECT 
'production_key_duplicate' AS CheckName,
COUNT(*) AS DuplicateCount
FROM
(
SELECT production_key, COUNT(*) jumlah
FROM fact.FactProduction
GROUP BY production_key
HAVING COUNT(*) > 1
) x;

GO


PRINT '================================';
PRINT '5. DATA RANGE VALIDATION';
PRINT '================================';


SELECT
'negative_operating_hours' AS CheckName,
COUNT(*) AS ErrorCount
FROM fact.FactEquipmentUsage
WHERE operating_hours < 0;

GO


PRINT '================================';
PRINT '6. README AGGREGATE VALIDATION';
PRINT '================================';


SELECT 
'FactEquipmentUsage' AS TableName,
COUNT(*) AS Total
FROM fact.FactEquipmentUsage

UNION ALL

SELECT 
'FactProduction',
COUNT(*)
FROM fact.FactProduction

UNION ALL

SELECT 
'FactFinancialTransaction',
COUNT(*)
FROM fact.FactFinancialTransaction;

GO


PRINT 'VALIDATION COMPLETE';