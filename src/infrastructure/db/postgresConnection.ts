import { Pool } from "pg";

const sslEnabled = process.env.DB_SSL === "true";

const pool = new Pool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  ssl: {
    rejectUnauthorized: false
  }
});

// CLAVE: para que "usuario" apunte a "citas.usuario"
pool.on("connect", async (client) => {
  await client.query("SET search_path TO citas, public");
});

export const query = (text: string, params?: any[]) => pool.query(text, params);
