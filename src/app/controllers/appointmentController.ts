import { Request, Response } from "express";
import { scheduleAppointment } from "../../domain/usecases/scheduleAppointment";

export const scheduleAppointmentController = async (
  req: Request,
  res: Response
) => {
  try {
    const userToken = (req as any).user;
    const pacienteId = userToken.userId as number;

    const { medicoId, especialidadId, fechaHora, motivo } = req.body;

    const cita = await scheduleAppointment({
      pacienteId,
      medicoId,
      especialidadId,
      fechaHora,
      motivo
    });

    res.status(201).json(cita);
  } catch (error: any) {
    res.status(400).json({ error: error.message });
  }
};
