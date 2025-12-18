import { userRepository } from "../../infrastructure/repositories/userRepository";

export const getUsers = async () => {
  return await userRepository.findAll();
};
