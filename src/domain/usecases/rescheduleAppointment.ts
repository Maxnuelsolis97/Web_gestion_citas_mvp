import { appointmentRepository } from "../../infrastructure/repositories/appointmentRepository";

function diffDays(from: Date, to: Date) {
  const ms = to.getTime() - from.getTime();
  return ms / (1000 * 60 * 60 * 24);
}

export const rescheduleAppointment = async ({
  pacienteId,
  citaId,
  nuevaFechaHora,
}: {
  pacienteId: number;
  citaId: number;
  nuevaFechaHora: string;
}) => {
  const nueva = new Date(nuevaFechaHora);
  if (isNaN(nueva.getTime())) throw new Error("La nueva fecha no es válida");

  const cita = await appointmentRepository.findByIdAndPacienteId(citaId, pacienteId);
  if (!cita) throw new Error("Cita no encontrada");

  const actual = new Date(cita.fecha_hora);
  const ahora = new Date();

  if (diffDays(ahora, actual) < 3) {
    throw new Error("Solo se puede postergar con mínimo 3 días de anticipación");
  }

  const updated = await appointmentRepository.reschedule(citaId, pacienteId, nuevaFechaHora);
  return updated;
};
