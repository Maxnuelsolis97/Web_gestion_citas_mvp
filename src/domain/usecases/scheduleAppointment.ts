import { appointmentRepository } from "../../infrastructure/repositories/appointmentRepository";

export const scheduleAppointment = async (data: {
  pacienteId: number;
  medicoId: number;
  especialidadId: number;
  fechaHora: string; // ISO
  motivo?: string;
}) => {
  const { pacienteId, medicoId, especialidadId, fechaHora, motivo } = data;

  const fecha = new Date(fechaHora);
  if (isNaN(fecha.getTime())) {
    throw new Error("La fecha de la cita no es válida");
  }

  const now = new Date();
  if (fecha <= now) {
    throw new Error("La cita debe ser en una fecha y hora futura");
  }

  const activeAppointments =
    await appointmentRepository.findActiveByPatient(pacienteId);
  if (activeAppointments.length > 0) {
    throw new Error("Ya tienes una cita activa");
  }

  const cita = await appointmentRepository.create({
    pacienteId,
    medicoId,
    especialidadId,
    fechaHora,
    motivo
  });

  return cita;
};
