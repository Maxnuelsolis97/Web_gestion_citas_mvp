import { Request, Response } from "express";
import { registerUser } from "../../domain/usecases/registerUser";
import { loginUser } from "../../domain/usecases/loginUser";

export const registerController = async (req: Request, res: Response) => {
  try {
    const user = await registerUser(req.body);
    res.json(user);
  } catch (error: any) {
    return res.status(400).json({ error: error.message });
  }
};

export const loginController = async (req: Request, res: Response) => {
  try {
    const result = await loginUser(req.body);
    res.json(result);
  } catch (error: any) {
    return res.status(400).json({ error: error.message });
  }
};
