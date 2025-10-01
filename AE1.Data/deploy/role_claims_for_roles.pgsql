-- Deploy AE1:role-claims-for-admin-and-user to pg

BEGIN;

-- Insert role claims for Admin role
INSERT INTO role_claims (role_id, claim_type, claim_value)
SELECT r.id, 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role', r.name
FROM roles r
WHERE r.name = 'Admin'
AND NOT EXISTS (
    SELECT 1 FROM role_claims rc 
    WHERE rc.role_id = r.id AND rc.claim_type = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role' AND rc.claim_value = r.name
);

-- Insert role claims for User role
INSERT INTO role_claims (role_id, claim_type, claim_value)
SELECT r.id, 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role', r.name
FROM roles r
WHERE r.name = 'User'
AND NOT EXISTS (
    SELECT 1 FROM role_claims rc 
    WHERE rc.role_id = r.id AND rc.claim_type = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role' AND rc.claim_value = r.name
);

COMMIT;