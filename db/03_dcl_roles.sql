-- db/03_dcl_roles.sql
-- DCL: crear app_user + permisos (sin DO $$, usando \gexec)

BEGIN;

-- 1) Crear rol app_user solo si NO existe
SELECT
  'CREATE ROLE app_user LOGIN PASSWORD ' || :'APP_PASS' || ';'
WHERE NOT EXISTS (
  SELECT 1 FROM pg_roles WHERE rolname = 'app_user'
)
\gexec

-- 2) Permisos mínimos (principio de menor privilegio)
GRANT CONNECT ON DATABASE current_database() TO app_user;
GRANT USAGE ON SCHEMA citas TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA citas
TO app_user;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA citas
TO app_user;

COMMIT;
