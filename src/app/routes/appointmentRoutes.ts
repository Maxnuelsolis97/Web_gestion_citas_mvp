import { Router } from "express";
import { authMiddleware } from "../middlewares/authMiddleware";
import {
  createAppointmentController,
  listAppointmentsController,
  rescheduleAppointmentController,
  cancelAppointmentController,
} from "../controllers/appointmentController";

const router = Router();

// Todas requieren login
router.post("/", authMiddleware, createAppointmentController);
router.get("/", authMiddleware, listAppointmentsController);
router.put("/:id/reschedule", authMiddleware, rescheduleAppointmentController);
router.delete("/:id", authMiddleware, cancelAppointmentController);

export default router;
