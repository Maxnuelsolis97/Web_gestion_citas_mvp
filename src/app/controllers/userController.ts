import { Request, Response } from "express";
import { getUsers } from "../../domain/usecases/getUsers";

export const getUsersController = async (_req: Request, res: Response) => {
  try {
    const users = await getUsers();
    res.json(users);
  } catch (error) {
    console.error("Error al obtener usuarios:", error);
    res.status(500).json({ error: "Error interno del servidor" });
  }
};
