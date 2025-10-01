-- Verify manyheads:identity-tables on pg

-- Verify user_status column is varchar (no longer enum)
SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'user_status' AND data_type = 'character varying';

-- Verify all Identity tables exist
SELECT 1/count(*) FROM information_schema.tables WHERE table_name = 'users' AND table_schema = 'public';
SELECT 1/count(*) FROM information_schema.tables WHERE table_name = 'roles' AND table_schema = 'public';
SELECT 1/count(*) FROM information_schema.tables WHERE table_name = 'user_claims' AND table_schema = 'public';
SELECT 1/count(*) FROM information_schema.tables WHERE table_name = 'role_claims' AND table_schema = 'public';
SELECT 1/count(*) FROM information_schema.tables WHERE table_name = 'user_roles' AND table_schema = 'public';
SELECT 1/count(*) FROM information_schema.tables WHERE table_name = 'user_logins' AND table_schema = 'public';
SELECT 1/count(*) FROM information_schema.tables WHERE table_name = 'user_tokens' AND table_schema = 'public';

-- Verify key columns exist according to specification
SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'id' AND data_type = 'uuid';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'email' AND is_nullable = 'NO';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'user_status' AND data_type = 'character varying';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'timezone';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'password_hash' AND is_nullable = 'NO';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'two_factor_enabled' AND data_type = 'boolean';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'two_factor_secret';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'sso_provider';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'sso_subject_id';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'created_at' AND is_nullable = 'NO';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'updated_at';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'is_deleted' AND data_type = 'boolean';

SELECT 1/count(*) FROM information_schema.columns 
WHERE table_name = 'users' AND column_name = 'revision_no' AND data_type = 'integer';

-- Verify foreign key constraints exist
SELECT 1/count(*) FROM information_schema.table_constraints 
WHERE table_name = 'users' AND constraint_name = 'fk_users_created_by' AND constraint_type = 'FOREIGN KEY';

SELECT 1/count(*) FROM information_schema.table_constraints 
WHERE table_name = 'users' AND constraint_name = 'fk_users_updated_by' AND constraint_type = 'FOREIGN KEY';

-- Verify trigger exists
SELECT 1/count(*) FROM information_schema.triggers 
WHERE trigger_name = 'update_users_updated_at' AND event_object_table = 'users';

-- Verify seeded roles exist
SELECT 1/count(*) FROM roles WHERE normalized_name = 'ADMIN';
SELECT 1/count(*) FROM roles WHERE normalized_name = 'USER';
