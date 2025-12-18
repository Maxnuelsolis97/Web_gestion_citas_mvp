import bcrypt from "bcryptjs";
import { userRepository } from "../../infrastructure/repositories/userRepository";

export const registerUser = async (data: {
  nombre: string;
  apellido: string;
  email: string;
  dni: string;
  password: string;
}) => {
  const { nombre, apellido, email, dni, password } = data;

  // Verificar si existe correo
  const exists = await userRepository.findByEmail(email);
  if (exists) {
    throw new Error("El correo ya está registrado");
  }

  // Encriptar contraseña
  const hashed = await bcrypt.hash(password, 10);

  // Registrar en BD
  return await userRepository.create({
    nombre,
    apellido,
    email,
    dni,
    password_hash: hashed
  });
};
