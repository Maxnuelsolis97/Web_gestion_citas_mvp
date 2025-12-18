CREATE TABLE usuario (
  id              SERIAL PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL,
  apellido        VARCHAR(100) NOT NULL,
  email           VARCHAR(150) NOT NULL UNIQUE,
  dni             VARCHAR(15)  NOT NULL UNIQUE,
  password_hash   VARCHAR(255) NOT NULL,
  estado          VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO',
  created_at      TIMESTAMP    NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE rol (
  id          SERIAL PRIMARY KEY,
  nombre      VARCHAR(50) NOT NULL UNIQUE,
  descripcion VARCHAR(200)
);

CREATE TABLE usuario_rol (
  usuario_id  INT NOT NULL,
  rol_id      INT NOT NULL,
  PRIMARY KEY (usuario_id, rol_id),
  CONSTRAINT fk_usuario_rol_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
  CONSTRAINT fk_usuario_rol_rol
    FOREIGN KEY (rol_id) REFERENCES rol(id)
);

CREATE TABLE especialidad (
  id          SERIAL PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL UNIQUE,
  descripcion VARCHAR(200),
  estado      VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE medico (
  id                  SERIAL PRIMARY KEY,
  usuario_id          INT NOT NULL,
  especialidad_id     INT NOT NULL,
  codigo_colegiatura  VARCHAR(50),
  estado              VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
  CONSTRAINT fk_medico_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
  CONSTRAINT fk_medico_especialidad
    FOREIGN KEY (especialidad_id) REFERENCES especialidad(id)
);

CREATE TABLE cita (
  id              SERIAL PRIMARY KEY,
  paciente_id     INT NOT NULL,
  medico_id       INT NOT NULL,
  especialidad_id INT NOT NULL,
  fecha_hora      TIMESTAMP NOT NULL,
  estado          VARCHAR(20) NOT NULL DEFAULT 'PROGRAMADA',
  motivo          VARCHAR(255),
  origen          VARCHAR(20) NOT NULL DEFAULT 'WEB',
  created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_cita_paciente
    FOREIGN KEY (paciente_id) REFERENCES usuario(id),
  CONSTRAINT fk_cita_medico
    FOREIGN KEY (medico_id) REFERENCES medico(id),
  CONSTRAINT fk_cita_especialidad
    FOREIGN KEY (especialidad_id) REFERENCES especialidad(id)
);

CREATE TABLE solicitud_postergacion (
  id                SERIAL PRIMARY KEY,
  cita_id           INT NOT NULL,
  paciente_id       INT NOT NULL,
  fecha_solicitada  TIMESTAMP NOT NULL,
  motivo            VARCHAR(1000) NOT NULL,
  estado            VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',
  respuesta_admin   VARCHAR(1000),
  usuario_admin_id  INT,
  created_at        TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMP NOT NULL DEFAULT NOW(),
  CONSTRAINT fk_solpos_cita
    FOREIGN KEY (cita_id) REFERENCES cita(id),
  CONSTRAINT fk_solpos_paciente
    FOREIGN KEY (paciente_id) REFERENCES usuario(id),
  CONSTRAINT fk_solpos_admin
    FOREIGN KEY (usuario_admin_id) REFERENCES usuario(id)
);

CREATE TABLE historial_cita (
  id                     SERIAL PRIMARY KEY,
  cita_id                INT NOT NULL,
  fecha_evento           TIMESTAMP NOT NULL DEFAULT NOW(),
  tipo_evento            VARCHAR(50) NOT NULL,
  descripcion            VARCHAR(1000),
  usuario_responsable_id INT NOT NULL,
  CONSTRAINT fk_hist_cita
    FOREIGN KEY (cita_id) REFERENCES cita(id),
  CONSTRAINT fk_hist_usuario
    FOREIGN KEY (usuario_responsable_id) REFERENCES usuario(id)
);
