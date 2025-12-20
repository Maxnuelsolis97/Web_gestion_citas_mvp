SET search_path TO citas;

-- Especialidades de prueba (idempotente sin depender de UNIQUE)
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

-- Médicos de prueba (idempotente)
INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT 'Dr. Juan Pérez', e.id, 'CMP-0001'
FROM especialidad e
WHERE e.nombre='Cardiología'
  AND NOT EXISTS (
    SELECT 1 FROM medico m WHERE m.codigo_colegiatura='CMP-0001'
  );

INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT 'Dra. María Gómez', e.id, 'CMP-0002'
FROM especialidad e
WHERE e.nombre='Medicina General'
  AND NOT EXISTS (
    SELECT 1 FROM medico m WHERE m.codigo_colegiatura='CMP-0002'
  );

INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT 'Dr. Luis Ramírez', e.id, 'CMP-0003'
FROM especialidad e
WHERE e.nombre='Pediatría'
  AND NOT EXISTS (
    SELECT 1 FROM medico m WHERE m.codigo_colegiatura='CMP-0003'
  );
