-- db/02_dml_seed.sql
SET search_path TO citas;

-- Especialidades de prueba
INSERT INTO especialidad (nombre, descripcion)
VALUES
  ('Cardiología', 'Especialidad del corazón'),
  ('Medicina General', 'Atención primaria'),
  ('Pediatría', 'Niños y adolescentes')
ON CONFLICT (nombre) DO NOTHING;

-- Médicos de prueba (sin ON CONFLICT para evitar error por falta de UNIQUE)
INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT 'Dr. Juan Pérez', e.id, 'CMP-0001'
FROM especialidad e
WHERE e.nombre = 'Cardiología'
  AND NOT EXISTS (
    SELECT 1 FROM medico m WHERE m.codigo_colegiatura = 'CMP-0001'
  );

INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT 'Dra. María Gómez', e.id, 'CMP-0002'
FROM especialidad e
WHERE e.nombre = 'Medicina General'
  AND NOT EXISTS (
    SELECT 1 FROM medico m WHERE m.codigo_colegiatura = 'CMP-0002'
  );

INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT 'Dr. Luis Ramírez', e.id, 'CMP-0003'
FROM especialidad e
WHERE e.nombre = 'Pediatría'
  AND NOT EXISTS (
    SELECT 1 FROM medico m WHERE m.codigo_colegiatura = 'CMP-0003'
  );
