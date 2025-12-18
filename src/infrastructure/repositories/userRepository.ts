import { query } from "../db/postgresConnection";

export interface CreateUserDTO {
  nombre: string;
  apellido: string;
  email: string;
  dni: string;
  password_hash: string;
}

export const userRepository = {
  async findAll() {
    const result = await query(
      "SELECT id, nombre, apellido, email FROM usuario"
    );
    return result.rows;
  },

  async findByEmail(email: string) {
    const result = await query(
      "SELECT * FROM usuario WHERE email = $1",
      [email]
    );
    return result.rows[0];
  },

  async create(data: CreateUserDTO) {
    const result = await query(
      `INSERT INTO usuario (nombre, apellido, email, dni, password_hash)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, nombre, apellido, email`,
      [data.nombre, data.apellido, data.email, data.dni, data.password_hash]
    );
    return result.rows[0];
  }
};
