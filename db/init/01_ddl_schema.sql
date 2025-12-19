-- 1) Re-crear schema limpio
DROP SCHEMA IF EXISTS citas CASCADE;
CREATE SCHEMA IF NOT EXISTS citas;
SET search_path TO citas;


CREATE TABLE IF NOT EXISTS usuario (
  id            BIGSERIAL NOT NULL,
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

CREATE TABLE IF NOT EXISTS especialidad (
  id          BIGSERIAL NOT NULL,
  nombre      VARCHAR(100) NOT NULL,
  descripcion VARCHAR(200),
  estado      VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE IF NOT EXISTS medico (
  id                 BIGSERIAL NOT NULL,
  nombre_completo    VARCHAR(200) NOT NULL,
  especialidad_id    BIGINT NOT NULL,
  codigo_colegiatura VARCHAR(50),
  estado             VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE IF NOT EXISTS cita (
  id              BIGSERIAL NOT NULL,
  paciente_id     BIGINT NOT NULL,
  medico_id       BIGINT NOT NULL,
  especialidad_id BIGINT NOT NULL,
  fecha_hora      TIMESTAMP NOT NULL,
  estado          VARCHAR(20) NOT NULL DEFAULT 'PROGRAMADA',
  codigo_pago     CHAR(5) NOT NULL,
  motivo          VARCHAR(255),
  created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMP NOT NULL DEFAULT NOW()
);


-- PK
ALTER TABLE usuario      ADD CONSTRAINT PK_USUARIO PRIMARY KEY (id);
ALTER TABLE especialidad ADD CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY (id);
ALTER TABLE medico       ADD CONSTRAINT PK_MEDICO PRIMARY KEY (id);
ALTER TABLE cita         ADD CONSTRAINT PK_CITA PRIMARY KEY (id);

-- Unique
ALTER TABLE usuario ADD CONSTRAINT UQ_USUARIO_EMAIL UNIQUE (email);
ALTER TABLE usuario ADD CONSTRAINT UQ_USUARIO_DNI   UNIQUE (dni);

ALTER TABLE especialidad ADD CONSTRAINT UQ_ESPECIALIDAD_NOMBRE UNIQUE (nombre);

-- Foreign Keys
ALTER TABLE medico
  ADD CONSTRAINT FK_MEDICO_ESPECIALIDAD
  FOREIGN KEY (especialidad_id) REFERENCES especialidad(id);

ALTER TABLE cita
  ADD CONSTRAINT FK_CITA_PACIENTE
  FOREIGN KEY (paciente_id) REFERENCES usuario(id);

ALTER TABLE cita
  ADD CONSTRAINT FK_CITA_MEDICO
  FOREIGN KEY (medico_id) REFERENCES medico(id);

ALTER TABLE cita
  ADD CONSTRAINT FK_CITA_ESPECIALIDAD
  FOREIGN KEY (especialidad_id) REFERENCES especialidad(id);

-- 4) ÍNDICES (con nombres)

CREATE INDEX IF NOT EXISTS IX_CITA_PACIENTE_ID     ON cita (paciente_id);
CREATE INDEX IF NOT EXISTS IX_CITA_MEDICO_ID       ON cita (medico_id);
CREATE INDEX IF NOT EXISTS IX_CITA_ESPECIALIDAD_ID ON cita (especialidad_id);
CREATE INDEX IF NOT EXISTS IX_CITA_FECHA_HORA      ON cita (fecha_hora);
