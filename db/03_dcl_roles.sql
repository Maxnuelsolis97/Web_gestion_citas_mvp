-- db/03_dcl_roles.sql
BEGIN;

-- Crear usuario de aplicación (no admin)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM pg_roles WHERE rolname = 'app_user'
  ) THEN
    EXECUTE format(
      'CREATE ROLE app_user LOGIN PASSWORD %L;',
      :'APP_PASS'
    );
  END IF;
END
$$;

-- Permisos mínimos (principio de menor privilegio)
GRANT CONNECT ON DATABASE current_database() TO app_user;
GRANT USAGE ON SCHEMA citas TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA citas
TO app_user;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA citas
TO app_user;

COMMIT;
