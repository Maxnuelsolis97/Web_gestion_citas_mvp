import { Router } from "express";
import { scheduleAppointmentController } from "../controllers/appointmentController";
import { authMiddleware } from "../middlewares/authMiddleware";

const router = Router();

// Todas las rutas de citas requieren estar logueado
router.post("/", authMiddleware, scheduleAppointmentController);

export default router;
