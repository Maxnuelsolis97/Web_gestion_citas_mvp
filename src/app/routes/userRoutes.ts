import { Router } from "express";
import { getUsersController } from "../controllers/userController";
import { authMiddleware } from "../middlewares/authMiddleware";

const router = Router();

router.get("/", authMiddleware, getUsersController);

export default router;
