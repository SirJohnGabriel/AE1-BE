-- Deploy manyheads:identity-tables to pg
-- requires: ext-pgcrypto

BEGIN;

-- Note: Using varchar instead of PostgreSQL enum for better reliability with .NET
-- Valid values: 'Invited', 'Active', 'Suspended', 'Disabled'

-- Roles table (converted from Identity/Roles.sql)
CREATE TABLE roles (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name varchar(256) NULL,
    normalized_name varchar(256) UNIQUE NULL,
    description text,
    concurrency_stamp text NULL,
    is_active boolean NOT NULL DEFAULT true
);

-- Users table (updated to match specification)
CREATE TABLE users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name varchar(255) NULL,
    last_name varchar(255) NULL,
    email varchar(255) NOT NULL,
    user_status varchar(20) NOT NULL DEFAULT 'Active' CHECK (user_status IN ('Invited', 'Active', 'Suspended', 'Disabled')),
    timezone varchar(100) DEFAULT 'UTC',
    password_hash varchar(255) NOT NULL,
    two_factor_enabled boolean NOT NULL DEFAULT false,
    two_factor_secret varchar(255) NULL,
    sso_provider varchar(50) NULL,
    sso_subject_id varchar(255) NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    created_by uuid NULL,
    updated_by uuid NULL,
    updated_at timestamptz NULL,
    is_deleted boolean NOT NULL DEFAULT false,
    revision_no integer NOT NULL DEFAULT 1,
    
    -- Legacy Identity fields (keeping for backward compatibility)
    user_name varchar(256) NULL,
    normalized_user_name varchar(256) UNIQUE NULL,
    normalized_email varchar(256) UNIQUE NULL,
    email_confirmed boolean NOT NULL DEFAULT false,
    security_stamp text NULL,
    concurrency_stamp text NULL,
    phone_number text NULL,
    phone_number_confirmed boolean NOT NULL DEFAULT false,
    lockout_end timestamptz NULL,
    lockout_enabled boolean NOT NULL DEFAULT false,
    access_failed_count integer NOT NULL DEFAULT 0
);

-- User Claims table (converted from Identity/UserClaims.sql)
CREATE TABLE user_claims (
    id serial PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    claim_type text NULL,
    claim_value text NULL
);

-- Role Claims table (converted from Identity/RoleClaims.sql)
CREATE TABLE role_claims (
    id serial PRIMARY KEY,
    role_id uuid NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    claim_type text NULL,
    claim_value text NULL
);

-- User Roles table (converted from Identity/UserRoles.sql)
CREATE TABLE user_roles (
    id uuid DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id uuid NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    effective_from timestamptz NOT NULL DEFAULT now(),
    effective_to timestamptz NULL,
    assigned_by uuid,
    assigned_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, role_id)
);

-- Create unique constraint for the Id column
CREATE UNIQUE INDEX uk_user_roles_id ON user_roles (id);

-- Add foreign key constraint for assigned_by in user_roles
ALTER TABLE user_roles ADD CONSTRAINT fk_user_roles_assigned_by FOREIGN KEY (assigned_by) REFERENCES users(id);

-- User Logins table (converted from Identity/UserLogins.sql)
CREATE TABLE user_logins (
    login_provider varchar(450) NOT NULL,
    provider_key varchar(450) NOT NULL,
    provider_display_name text NULL,
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (login_provider, provider_key)
);

-- User Tokens table (converted from Identity/UserTokens.sql)
CREATE TABLE user_tokens (
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    login_provider varchar(450) NOT NULL,
    name varchar(450) NOT NULL,
    value text NULL,
    PRIMARY KEY (user_id, login_provider, name)
);

-- Add foreign key constraints for audit fields
-- Note: created_by and updated_by reference users table (self-referencing)
ALTER TABLE users ADD CONSTRAINT fk_users_created_by FOREIGN KEY (created_by) REFERENCES users(id);
ALTER TABLE users ADD CONSTRAINT fk_users_updated_by FOREIGN KEY (updated_by) REFERENCES users(id);

-- Create trigger function for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for users table
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Create indexes for performance
CREATE INDEX ix_users_normalized_user_name ON users(normalized_user_name);
CREATE INDEX ix_users_normalized_email ON users(normalized_email);
CREATE INDEX ix_users_email ON users(email);
CREATE INDEX ix_users_user_status ON users(user_status);
CREATE INDEX ix_users_created_by ON users(created_by);
CREATE INDEX ix_users_updated_by ON users(updated_by);
CREATE INDEX ix_users_is_deleted ON users(is_deleted);
CREATE INDEX ix_roles_normalized_name ON roles(normalized_name);
CREATE INDEX ix_user_claims_user_id ON user_claims(user_id);
CREATE INDEX ix_role_claims_role_id ON role_claims(role_id);
CREATE INDEX ix_user_logins_user_id ON user_logins(user_id);

-- Seed default roles
INSERT INTO roles (name, normalized_name, description, concurrency_stamp)
VALUES 
    ('Admin', 'ADMIN', 'Admin account', gen_random_uuid()::text),
    ('User', 'USER', 'General user account', gen_random_uuid()::text)
ON CONFLICT (normalized_name) DO UPDATE SET 
    concurrency_stamp = gen_random_uuid()::text;

COMMIT;
