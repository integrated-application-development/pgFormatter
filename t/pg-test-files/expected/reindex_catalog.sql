--
-- Check that system tables can be reindexed.
--
-- Note that this test currently has to run without parallel tests
-- being scheduled, as currently reindex catalog tables can cause
-- deadlocks:
--
-- * The lock upgrade between the ShareLock acquired for the reindex
--   and RowExclusiveLock needed for pg_class/pg_index locks can
--   trigger deadlocks.
--
-- * The uniqueness checks performed when reindexing a unique/primary
--   key index possibly need to wait for the transaction of a
--   about-to-deleted row in pg_class to commit. That can cause
--   deadlocks because, in contrast to user tables, locks on catalog
--   tables are routinely released before commit - therefore the lock
--   held for reindexing doesn't guarantee that no running transaction
--   performed modifications in the table underlying the index.
-- Check reindexing of whole tables
REINDEX TABLE pg_class;

-- mapped, non-shared, critical
REINDEX TABLE pg_index;

-- non-mapped, non-shared, critical
REINDEX TABLE pg_operator;

-- non-mapped, non-shared, critical
REINDEX TABLE pg_database;

-- mapped, shared, critical
REINDEX TABLE pg_shdescription;

-- mapped, shared non-critical
-- Check that individual system indexes can be reindexed. That's a bit
-- different from the entire-table case because reindex_relation
-- treats e.g. pg_class special.
REINDEX INDEX pg_class_oid_index;

-- mapped, non-shared, critical
REINDEX INDEX pg_class_relname_nsp_index;

-- mapped, non-shared, non-critical
REINDEX INDEX pg_index_indexrelid_index;

-- non-mapped, non-shared, critical
REINDEX INDEX pg_index_indrelid_index;

-- non-mapped, non-shared, non-critical
REINDEX INDEX pg_database_oid_index;

-- mapped, shared, critical
REINDEX INDEX pg_shdescription_o_c_index;

-- mapped, shared, non-critical
