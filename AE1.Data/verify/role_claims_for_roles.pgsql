-- Verify AE1:role-claims-for-admin-and-user on pg

BEGIN;

-- Verify that Admin role has the expected role claim
SELECT 1/count(*) FROM role_claims rc
JOIN roles r ON rc.role_id = r.id
WHERE r.name = 'Admin' 
AND rc.claim_type = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role' 
AND rc.claim_value = 'Admin'
HAVING count(*) = 1;

-- Verify that Project Creator role has the expected role claim
SELECT 1/count(*) FROM role_claims rc
JOIN roles r ON rc.role_id = r.id
WHERE r.name = 'User' 
AND rc.claim_type = 'http://schemas.microsoft.com/ws/2008/06/identity/claims/role' 
AND rc.claim_value = 'User'
HAVING count(*) = 1;

ROLLBACK;