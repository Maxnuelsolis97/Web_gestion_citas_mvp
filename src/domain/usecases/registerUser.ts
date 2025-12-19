import { userRepository } from "../../infrastructure/repositories/userRepository";

export const registerUser = async (data: any) => {
  const { nombre, apellido, email, dni, celular, password } = data;

  if (!nombre || !apellido || !email || !dni || !password) {
    throw new Error("Faltan campos obligatorios");
  }

  const exists = await userRepository.findByEmail(email);
  if (exists) throw new Error("El correo ya está registrado");

  return await userRepository.create({ nombre, apellido, email, dni, celular, password });
};
