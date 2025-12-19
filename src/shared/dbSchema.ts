export const DB_SCHEMA = process.env.DB_SCHEMA || "public";

export const t = (table: string) => `"${DB_SCHEMA}"."${table}"`;
    