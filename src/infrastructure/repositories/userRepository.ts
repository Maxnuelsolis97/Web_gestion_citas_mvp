import { query } from "../db/postgresConnection";
import bcrypt from "bcryptjs";

export const userRepository = {
  async findAll() {
    const result = await query(
      "SELECT id, nombre, apellido, email, dni, celular, created_at FROM usuario ORDER BY id ASC"
    );
    return result.rows;
  },

  async findByEmail(email: string) {
    const result = await query("SELECT * FROM usuario WHERE email = $1", [email]);
    return result.rows[0];
  },

  async create(data: {
    nombre: string;
    apellido: string;
    email: string;
    dni: string;
    celular?: string;
    password: string;
  }) {
    const password_hash = await bcrypt.hash(data.password, 10);

    const result = await query(
      `INSERT INTO usuario (nombre, apellido, email, dni, celular, password_hash)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING id, nombre, apellido, email, dni, celular, created_at`,
      [data.nombre, data.apellido, data.email, data.dni, data.celular ?? null, password_hash]
    );

    return result.rows[0];
  },
};
