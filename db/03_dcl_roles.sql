-- Se ejecuta conectado como ADMIN (por CI/CD) para crear usuario de aplicación NO admin
-- Recibe el password por variable: :APP_PASS

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user') THEN
    CREATE ROLE app_user LOGIN PASSWORD :'APP_PASS';
  ELSE
    ALTER ROLE app_user WITH LOGIN PASSWORD :'APP_PASS';
  END IF;
END $$;

-- Permisos mínimos necesarios
GRANT USAGE ON SCHEMA citas TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA citas TO app_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA citas TO app_user;

-- Para que futuras tablas también queden con permisos
ALTER DEFAULT PRIVILEGES IN SCHEMA citas
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA citas
GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO app_user;
