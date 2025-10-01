-- Revert manyheads:identity-tables from pg

BEGIN;

-- Drop trigger and function
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
DROP FUNCTION IF EXISTS update_updated_at_column();

-- Drop indexes
DROP INDEX IF EXISTS ix_user_logins_user_id;
DROP INDEX IF EXISTS ix_role_claims_role_id;
DROP INDEX IF EXISTS ix_user_claims_user_id;
DROP INDEX IF EXISTS ix_roles_normalized_name;
DROP INDEX IF EXISTS ix_users_is_deleted;
DROP INDEX IF EXISTS ix_users_updated_by;
DROP INDEX IF EXISTS ix_users_created_by;
DROP INDEX IF EXISTS ix_users_user_status;
DROP INDEX IF EXISTS ix_users_email;
DROP INDEX IF EXISTS ix_users_normalized_email;
DROP INDEX IF EXISTS ix_users_normalized_user_name;

-- Drop tables in reverse order due to foreign key constraints
DROP TABLE IF EXISTS user_tokens;
DROP TABLE IF EXISTS user_logins;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS role_claims;
DROP TABLE IF EXISTS user_claims;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

-- Drop enum type
DROP TYPE IF EXISTS user_status;

COMMIT;
