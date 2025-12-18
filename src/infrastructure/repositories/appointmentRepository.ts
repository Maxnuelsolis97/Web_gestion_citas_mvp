import { query } from "../db/postgresConnection";

export interface CreateAppointmentDTO {
  pacienteId: number;
  medicoId: number;
  especialidadId: number;
  fechaHora: string; // ISO: "2025-11-30T10:00:00"
  motivo?: string;
}

export const appointmentRepository = {
  async create(data: CreateAppointmentDTO) {
    const result = await query(
  `INSERT INTO cita (paciente_id, medico_id, especialidad_id, fecha_hora, motivo, estado)
   VALUES ($1, $2, $3, $4, $5, 'PROGRAMADA')
   RETURNING id, paciente_id, medico_id, especialidad_id, fecha_hora, motivo, estado`,
  [
    data.pacienteId,
    data.medicoId,
    data.especialidadId,
    data.fechaHora,
    data.motivo || null
  ]
);
    return result.rows[0];
  },

  async findActiveByPatient(pacienteId: number) {
    const result = await query(
      `SELECT id, paciente_id, medico_id, especialidad_id, fecha_hora, motivo, estado
       FROM cita
       WHERE paciente_id = $1 AND estado = 'ACTIVA'`,
      [pacienteId]
    );
    return result.rows;
  }
};
