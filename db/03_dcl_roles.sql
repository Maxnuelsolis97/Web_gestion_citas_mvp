-- db/03_dcl_roles.sql
-- DCL: crear app_user + permisos
-- Se ejecuta con: psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -v APP_PASS="..." -f db/03_dcl_roles.sql

BEGIN;

-- Guardamos el password del secret en un setting local (evita problemas de parseo)
SET LOCAL app.app_pass = :'APP_PASS';

DO $$
DECLARE
  v_pass text;
BEGIN
  v_pass := current_setting('app.app_pass', true);

  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user') THEN
    EXECUTE format('CREATE ROLE app_user LOGIN PASSWORD %L', v_pass);
  END IF;

  -- GRANT CONNECT necesita nombre real de la BD, no current_database()
  EXECUTE format('GRANT CONNECT ON DATABASE %I TO app_user', current_database());
END $$;

-- Permisos en schema/objetos
GRANT USAGE ON SCHEMA citas TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA citas
TO app_user;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA citas
TO app_user;

-- Para futuras tablas/secuencias creadas por el owner actual
ALTER DEFAULT PRIVILEGES IN SCHEMA citas
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA citas
GRANT USAGE, SELECT ON SEQUENCES TO app_user;

COMMIT;
