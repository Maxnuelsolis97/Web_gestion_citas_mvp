-- db/03_dcl_roles.sql
-- DCL: crear usuario app_user + permisos mínimos
-- Se ejecuta con psql y variable APP_PASS desde GitHub Actions:
-- psql ... -v APP_PASS="$APP_PASS" -f db/03_dcl_roles.sql

SET search_path TO citas;

-- 1) Crear rol si no existe (idempotente)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user') THEN
    EXECUTE format('CREATE ROLE app_user LOGIN PASSWORD %L', :'APP_PASS');
  END IF;
END $$;

-- 2) Asegurar permisos sobre el schema y objetos
GRANT USAGE ON SCHEMA citas TO app_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA citas
TO app_user;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA citas
TO app_user;

-- 3) Para tablas/secuencias futuras
ALTER DEFAULT PRIVILEGES IN SCHEMA citas
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA citas
GRANT USAGE, SELECT ON SEQUENCES TO app_user;
