import { query } from "../db/postgresConnection";

export interface CreateAppointmentDTO {
  pacienteId: number;
  medicoId: number;
  especialidadId: number;
  fechaHora: string; // ISO
  motivo?: string;
}

export const appointmentRepository = {
  async create(data: CreateAppointmentDTO) {
    const result = await query(
      `
      INSERT INTO citas.cita
        (paciente_id, medico_id, especialidad_id, fecha_hora, motivo, estado)
      VALUES
        ($1, $2, $3, $4, $5, 'PROGRAMADA')
      RETURNING id, paciente_id, medico_id, especialidad_id, fecha_hora, motivo, estado
      `,
      [
        data.pacienteId,
        data.medicoId,
        data.especialidadId,
        data.fechaHora,
        data.motivo ?? null,
      ]
    );
    return result.rows[0];
  },

  async listByPacienteId(pacienteId: number) {
    const result = await query(
      `
      SELECT id, paciente_id, medico_id, especialidad_id, fecha_hora, motivo, estado
      FROM citas.cita
      WHERE paciente_id = $1
      ORDER BY fecha_hora DESC
      `,
      [pacienteId]
    );
    return result.rows;
  },

  async findByIdAndPacienteId(citaId: number, pacienteId: number) {
    const result = await query(
      `
      SELECT id, paciente_id, medico_id, especialidad_id, fecha_hora, motivo, estado
      FROM citas.cita
      WHERE id = $1 AND paciente_id = $2
      LIMIT 1
      `,
      [citaId, pacienteId]
    );
    return result.rows[0] ?? null;
  },

  async reschedule(citaId: number, pacienteId: number, nuevaFechaHora: string) {
    const result = await query(
      `
      UPDATE citas.cita
      SET fecha_hora = $1, updated_at = now()
      WHERE id = $2 AND paciente_id = $3
      RETURNING id, paciente_id, medico_id, especialidad_id, fecha_hora, motivo, estado
      `,
      [nuevaFechaHora, citaId, pacienteId]
    );
    return result.rows[0];
  },

  async cancel(citaId: number, pacienteId: number) {
    await query(
      `
      UPDATE citas.cita
      SET estado = 'CANCELADA', updated_at = now()
      WHERE id = $1 AND paciente_id = $2
      `,
      [citaId, pacienteId]
    );
  },

};
