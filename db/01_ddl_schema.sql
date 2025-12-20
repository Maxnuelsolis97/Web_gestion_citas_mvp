-- db/01_ddl_schema.sql
-- DDL: Schema + tablas + constraints + indices + function/trigger + "sinónimos" (views)

BEGIN;

-- 1) Re-crear schema limpio (modo demo)
DROP SCHEMA IF EXISTS citas CASCADE;
CREATE SCHEMA citas;
SET search_path TO citas;

-- 2) Tablas
CREATE TABLE usuario (
  id            BIGSERIAL PRIMARY KEY,
  nombre        VARCHAR(100) NOT NULL,
  apellido      VARCHAR(100) NOT NULL,
  email         VARCHAR(150) NOT NULL,
  dni           VARCHAR(15)  NOT NULL,
  celular       VARCHAR(20)  NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  estado        VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO',
  created_at    TIMESTAMP    NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE especialidad (
  id          BIGSERIAL PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL,
  descripcion VARCHAR(200),
  estado      VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE medico (
  id                 BIGSERIAL PRIMARY KEY,
  nombre_completo    VARCHAR(200) NOT NULL,
  especialidad_id    BIGINT NOT NULL,
  codigo_colegiatura VARCHAR(50),
  estado             VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE cita (
  id              BIGSERIAL PRIMARY KEY,
  paciente_id     BIGINT NOT NULL,
  medico_id       BIGINT NOT NULL,
  especialidad_id BIGINT NOT NULL,
  fecha_hora      TIMESTAMP NOT NULL,
  estado          VARCHAR(20) NOT NULL DEFAULT 'PROGRAMADA',

  -- Ya NO lo usan: lo dejamos NULLABLE para evitar errores.
  codigo_pago     CHAR(5) NULL,

  motivo          VARCHAR(255),
  created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 3) Unique constraints
ALTER TABLE usuario
  ADD CONSTRAINT uq_usuario_email UNIQUE (email);

ALTER TABLE usuario
  ADD CONSTRAINT uq_usuario_dni UNIQUE (dni);

ALTER TABLE especialidad
  ADD CONSTRAINT uq_especialidad_nombre UNIQUE (nombre);

-- 4) Foreign keys (constraints)
ALTER TABLE medico
  ADD CONSTRAINT fk_medico_especialidad
  FOREIGN KEY (especialidad_id) REFERENCES especialidad(id);

ALTER TABLE cita
  ADD CONSTRAINT fk_cita_paciente
  FOREIGN KEY (paciente_id) REFERENCES usuario(id);

ALTER TABLE cita
  ADD CONSTRAINT fk_cita_medico
  FOREIGN KEY (medico_id) REFERENCES medico(id);

ALTER TABLE cita
  ADD CONSTRAINT fk_cita_especialidad
  FOREIGN KEY (especialidad_id) REFERENCES especialidad(id);

-- 5) Índices
CREATE INDEX ix_cita_paciente_id     ON cita (paciente_id);
CREATE INDEX ix_cita_medico_id       ON cita (medico_id);
CREATE INDEX ix_cita_especialidad_id ON cita (especialidad_id);
CREATE INDEX ix_cita_fecha_hora      ON cita (fecha_hora);

-- 6) Función + trigger para updated_at (cumple "funciones")
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_usuario_updated
BEFORE UPDATE ON usuario
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER tr_cita_updated
BEFORE UPDATE ON cita
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

-- 7) "Sinónimos" en PostgreSQL: Views (alias de objetos)
-- Nota: PostgreSQL no tiene SINONYM nativo como Oracle; se usa VIEW para cubrir el alias.
CREATE OR REPLACE VIEW v_usuario AS
SELECT * FROM usuario;

CREATE OR REPLACE VIEW v_cita AS
SELECT * FROM cita;

COMMIT;
