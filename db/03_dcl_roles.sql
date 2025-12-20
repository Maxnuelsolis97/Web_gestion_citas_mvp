-- db/03_dcl_roles.sql
-- DCL: crear app_user + permisos (robusto con password numérico)

BEGIN;

-- Crear role solo si no existe (usando SQL generado y ejecutado)
SELECT
  'CREATE ROLE app_user LOGIN PASSWORD '
  || quote_literal(replace(:'APP_PASS', '''', ''''''))
  || ';'
WHERE NOT EXISTS (
  SELECT 1 FROM pg_roles WHERE rolname = 'app_user'
)
\gexec

-- Permisos mínimos
GRANT CONNECT ON DATABASE current_database() TO app_user;
GRANT USAGE ON SCHEMA citas TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA citas
TO app_user;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA citas
TO app_user;

COMMIT;
