import { appointmentRepository } from "../../infrastructure/repositories/appointmentRepository";

function diffDays(from: Date, to: Date) {
  const ms = to.getTime() - from.getTime();
  return ms / (1000 * 60 * 60 * 24);
}

export const cancelAppointment = async ({
  pacienteId,
  citaId,
}: {
  pacienteId: number;
  citaId: number;
}) => {
  const cita = await appointmentRepository.findByIdAndPacienteId(citaId, pacienteId);
  if (!cita) throw new Error("Cita no encontrada");

  const fecha = new Date(cita.fecha_hora);
  const ahora = new Date();

  if (diffDays(ahora, fecha) < 3) {
    throw new Error("Solo se puede cancelar con mínimo 3 días de anticipación");
  }

  await appointmentRepository.cancel(citaId, pacienteId);
  return { message: "Cita cancelada correctamente" };
};
