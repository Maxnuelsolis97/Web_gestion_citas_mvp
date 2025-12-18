import bcrypt from "bcryptjs";
import jwt, { SignOptions, Secret } from "jsonwebtoken";
import { userRepository } from "../../infrastructure/repositories/userRepository";

export const loginUser = async (data: { email: string; password: string }) => {
  const { email, password } = data;

  const user = await userRepository.findByEmail(email);
  if (!user) {
    throw new Error("Credenciales inválidas");
  }

  const isValid = await bcrypt.compare(password, user.password_hash);
  if (!isValid) {
    throw new Error("Credenciales inválidas");
  }

  const secretEnv = process.env.JWT_SECRET;
  if (!secretEnv) {
    throw new Error("JWT_SECRET no está configurado");
  }

  const secret: Secret = secretEnv;

  const expiresInValue: SignOptions["expiresIn"] =
    (process.env.JWT_EXPIRES_IN || "1h") as SignOptions["expiresIn"];

  const payload = {
    userId: user.id,
    email: user.email
    // aquí luego podremos agregar roles
  };

  const options: SignOptions = {
    expiresIn: expiresInValue
  };

  const token = jwt.sign(payload, secret, options);

  return {
    token,
    user: {
      id: user.id,
      nombre: user.nombre,
      apellido: user.apellido,
      email: user.email
    }
  };
};
