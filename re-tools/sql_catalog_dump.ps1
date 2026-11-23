# Dump the schema catalog (no row data) of a database to JSON files.
# usage: powershell -File sql_catalog_dump.ps1 -Db TraderRE -Out C:\Projects\Abuzar\db\catalog
param([string]$Db = 'TraderRE', [string]$Out = 'C:\Projects\Abuzar\db\catalog', [string]$Server = '.')
New-Item -ItemType Directory -Force $Out | Out-Null

$q = [ordered]@{}
$q.tables = @"
SELECT t.object_id, s.name AS [schema], t.name, t.create_date, t.modify_date, t.is_ms_shipped,
       (SELECT SUM(p.rows) FROM sys.partitions p WHERE p.object_id = t.object_id AND p.index_id IN (0,1)) AS row_count
FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id ORDER BY s.name, t.name
"@
$q.columns = @"
SELECT c.object_id, c.column_id, c.name, ty.name AS type, c.max_length, c.precision, c.scale, c.is_nullable,
       c.is_identity, ic.seed_value, ic.increment_value, c.is_computed, cc.definition AS computed_definition,
       c.collation_name, dc.name AS default_name, dc.definition AS default_definition, c.is_rowguidcol
FROM sys.columns c
JOIN sys.tables t ON t.object_id = c.object_id
JOIN sys.types ty ON ty.user_type_id = c.user_type_id
LEFT JOIN sys.identity_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT JOIN sys.computed_columns cc ON cc.object_id = c.object_id AND cc.column_id = c.column_id
LEFT JOIN sys.default_constraints dc ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
ORDER BY c.object_id, c.column_id
"@
$q.indexes = @"
SELECT i.object_id, i.index_id, i.name, i.type_desc, i.is_unique, i.is_primary_key, i.is_unique_constraint,
       i.is_disabled, i.filter_definition, ic.key_ordinal, ic.is_descending_key, ic.is_included_column, col.name AS column_name
FROM sys.indexes i
JOIN sys.tables t ON t.object_id = i.object_id
JOIN sys.index_columns ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns col ON col.object_id = ic.object_id AND col.column_id = ic.column_id
WHERE i.index_id > 0 ORDER BY i.object_id, i.index_id, ic.is_included_column, ic.key_ordinal
"@
$q.foreign_keys = @"
SELECT fk.object_id, fk.name, fk.parent_object_id, fk.referenced_object_id, fk.delete_referential_action_desc,
       fk.update_referential_action_desc, fk.is_disabled, fk.is_not_trusted, fkc.constraint_column_id,
       pc.name AS parent_column, rc.name AS referenced_column
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
JOIN sys.columns pc ON pc.object_id = fkc.parent_object_id AND pc.column_id = fkc.parent_column_id
JOIN sys.columns rc ON rc.object_id = fkc.referenced_object_id AND rc.column_id = fkc.referenced_column_id
ORDER BY fk.object_id, fkc.constraint_column_id
"@
$q.check_constraints = "SELECT object_id, parent_object_id, name, definition, is_disabled FROM sys.check_constraints"
$q.modules = @"
SELECT o.object_id, o.type, o.type_desc, s.name AS [schema], o.name, o.parent_object_id, o.create_date, o.modify_date,
       m.definition, m.is_schema_bound, m.uses_ansi_nulls, m.uses_quoted_identifier
FROM sys.objects o JOIN sys.schemas s ON s.schema_id = o.schema_id
JOIN sys.sql_modules m ON m.object_id = o.object_id WHERE o.is_ms_shipped = 0 ORDER BY o.type, o.name
"@
$q.parameters = @"
SELECT p.object_id, p.parameter_id, p.name, ty.name AS type, p.max_length, p.precision, p.scale, p.is_output, p.has_default_value
FROM sys.parameters p JOIN sys.objects o ON o.object_id = p.object_id JOIN sys.types ty ON ty.user_type_id = p.user_type_id
WHERE o.is_ms_shipped = 0 ORDER BY p.object_id, p.parameter_id
"@
$q.dependencies = @"
SELECT d.referencing_id, OBJECT_NAME(d.referencing_id) AS referencing_name, d.referenced_entity_name, d.referenced_schema_name, d.referenced_id
FROM sys.sql_expression_dependencies d
"@
$q.user_types = "SELECT name, system_type_id, user_type_id, max_length, precision, scale, is_nullable FROM sys.types WHERE is_user_defined = 1"
$q.synonyms_sequences = "SELECT 'sequence' AS kind, name FROM sys.sequences UNION ALL SELECT 'synonym', name FROM sys.synonyms"
$q.users = "SELECT name, type_desc FROM sys.database_principals WHERE principal_id > 4 AND type IN ('S','U','G','R')"
$q.database = "SELECT name, compatibility_level, collation_name, recovery_model_desc FROM sys.databases WHERE name = DB_NAME()"

$cn = New-Object System.Data.SqlClient.SqlConnection("Server=$Server;Database=$Db;Integrated Security=SSPI;TrustServerCertificate=True")
$cn.Open()
foreach ($k in $q.Keys) {
    $cmd = $cn.CreateCommand(); $cmd.CommandText = $q[$k]; $cmd.CommandTimeout = 600
    $rd = $cmd.ExecuteReader()
    $rows = New-Object System.Collections.Generic.List[string]
    while ($rd.Read()) {
        $o = [ordered]@{}
        for ($i = 0; $i -lt $rd.FieldCount; $i++) {
            $v = $rd.GetValue($i)
            if ($v -is [System.DBNull]) { $v = $null } elseif ($v -is [datetime]) { $v = $v.ToString('s') } elseif ($v -is [byte[]]) { $v = $null }
            $o[$rd.GetName($i)] = $v
        }
        $rows.Add(($o | ConvertTo-Json -Compress -Depth 3))
    }
    $rd.Close()
    [System.IO.File]::WriteAllLines("$Out\$k.jsonl", $rows, (New-Object System.Text.UTF8Encoding($false)))
    "{0}: {1} rows" -f $k, $rows.Count
}
$cn.Close()
