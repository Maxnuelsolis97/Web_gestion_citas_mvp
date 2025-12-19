import { appointmentRepository } from "../../infrastructure/repositories/appointmentRepository";

function parseISOOrThrow(value: string): Date {
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) throw new Error("La fecha de la cita no es válida (ISO).");
  return d;
}

function mustBeAtLeast3DaysBefore(fechaCita: Date) {
  const now = new Date();
  const diffMs = fechaCita.getTime() - now.getTime();
  const diffDays = diffMs / (1000 * 60 * 60 * 24);
  if (diffDays < 3) {
    throw new Error("Solo se permite con mínimo 3 días de anticipación.");
  }
}

export async function scheduleAppointment(input: {
  pacienteId: number;
  medicoId: number;
  especialidadId: number;
  fechaHora: string;
  motivo?: string;
}) {
  const fecha = parseISOOrThrow(input.fechaHora);

  // Debe ser futura
  if (fecha.getTime() <= Date.now()) {
    throw new Error("La fecha de la cita debe ser futura.");
  }


  return appointmentRepository.create(input);
}

export function validarCambioConAnticipacion(fechaHoraISO: string) {
  const fecha = parseISOOrThrow(fechaHoraISO);
  mustBeAtLeast3DaysBefore(fecha);
}
