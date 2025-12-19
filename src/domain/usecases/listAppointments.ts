import { appointmentRepository } from "../../infrastructure/repositories/appointmentRepository";

export const listAppointments = async ({ pacienteId }: { pacienteId: number }) => {
  return appointmentRepository.listByPacienteId(pacienteId);
};
