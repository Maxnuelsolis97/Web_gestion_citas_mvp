-- db/02_dml_seed.sql
-- DML: data de prueba mínima para demo

BEGIN;

SET search_path TO citas;

-- Especialidades
INSERT INTO especialidad (nombre, descripcion)
VALUES
('Cardiología', 'Especialidad del corazón'),
('Medicina General', 'Atención primaria'),
('Pediatría', 'Niños y adolescentes')
ON CONFLICT (nombre) DO NOTHING;

-- Médicos (mínimo 1 por especialidad)
INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT 'Dr. Juan Pérez', e.id, 'CMP-0001'
FROM especialidad e
WHERE e.nombre = 'Cardiología'
ON CONFLICT DO NOTHING;

INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT 'Dra. María Gómez', e.id, 'CMP-0002'
FROM especialidad e
WHERE e.nombre = 'Medicina General'
ON CONFLICT DO NOTHING;

INSERT INTO medico (nombre_completo, especialidad_id, codigo_colegiatura)
SELECT 'Dr. Luis Ramírez', e.id, 'CMP-0003'
FROM especialidad e
WHERE e.nombre = 'Pediatría'
ON CONFLICT DO NOTHING;

COMMIT;
