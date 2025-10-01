-- Revert AE1:role-claims-for-admin-and-user from pg

BEGIN;

-- Remove role claims for Admin role
DELETE FROM role_claims 
WHERE role_id IN (
    SELECT r.id FROM roles r WHERE r.name = 'Admin'
) 
AND claim_type = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role' 
AND claim_value = 'Admin';

-- Remove role claims for User role
DELETE FROM role_claims 
WHERE role_id IN (
    SELECT r.id FROM roles r WHERE r.name = 'User'
) 
AND claim_type = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role' 
AND claim_value = 'User';

COMMIT;