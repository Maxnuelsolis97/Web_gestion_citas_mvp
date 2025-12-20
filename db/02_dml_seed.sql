-- db/02_dml_seed.sql
SET search_path TO citas;

-- Especialidades
INSERT INTO especialidad (nombre, descripcion)
SELECT v.nombre, v.descripcion
FROM (VALUES
  ('Cardiología', 'Especialidad del corazón'),
  ('Medicina General', 'Atención primaria'),
  ('Pediatría', 'Niños y adolescentes')
) AS v(nombre, descripcion)
WHERE NOT EXISTS (
  SELECT 1 FROM especialidad e WHERE e.nombre = v.nombre
);

-- Médicos de prueba (evita duplicados por nombre_completo)
INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT v.nombre_completo, e.id, v.codigo_colegiatura
FROM (VALUES
  ('Dr. Juan Pérez', 'Cardiología', 'CMP-0001'),
  ('Dra. María Gómez', 'Medicina General', 'CMP-0002'),
  ('Dr. Luis Ramírez', 'Pediatría', 'CMP-0003')
) AS v(nombre_completo, especialidad_nombre, codigo_colegiatura)
JOIN especialidad e ON e.nombre = v.especialidad_nombre
WHERE NOT EXISTS (
  SELECT 1 FROM medico m WHERE m.nombre_completo = v.nombre_completo
);
