import { Router } from "express";
import { authMiddleware } from "../middlewares/authMiddleware";
import {
  createAppointmentController,
  listAppointmentsController,
} from "../controllers/appointmentController";

const router = Router();

// Todas requieren login
router.post("/", authMiddleware, createAppointmentController);
router.get("/", authMiddleware, listAppointmentsController);

export default router;
