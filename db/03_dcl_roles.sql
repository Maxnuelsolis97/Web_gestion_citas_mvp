-- db/03_dcl_roles.sql
-- Crea usuario de aplicación y permisos mínimos (no admin)

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user') THEN
    CREATE ROLE app_user LOGIN PASSWORD :'APP_PASS';
  END IF;
END
$$;

-- Permisos básicos sobre schema y tablas
GRANT USAGE ON SCHEMA citas TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA citas TO app_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA citas TO app_user;

-- Para que futuras tablas/secuencias también queden con permisos
ALTER DEFAULT PRIVILEGES IN SCHEMA citas
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA citas
  GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO app_user;
