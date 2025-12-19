import { Request, Response } from "express";
import { scheduleAppointment } from "../../domain/usecases/scheduleAppointment";
import { listAppointments } from "../../domain/usecases/listAppointments";


export const createAppointmentController = async (req: Request, res: Response) => {
  try {
    const userToken = (req as any).user;
    const pacienteId = userToken.userId as number;

    const { medicoId, especialidadId, fechaHora, motivo } = req.body;

    const cita = await scheduleAppointment({
      pacienteId,
      medicoId,
      especialidadId,
      fechaHora,
      motivo,
    });

    return res.status(201).json(cita);
  } catch (error: any) {
    return res.status(400).json({ error: error.message });
  }
};

export const listAppointmentsController = async (req: Request, res: Response) => {
  try {
    const userToken = (req as any).user;
    const pacienteId = userToken.userId as number;

    const citas = await listAppointments({ pacienteId });
    return res.status(200).json(citas);
  } catch (error: any) {
    return res.status(400).json({ error: error.message });
  }
};

