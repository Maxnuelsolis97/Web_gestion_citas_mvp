import express from "express";
import cors, { CorsOptions } from "cors";

// Si usas dotenv en tu proyecto, descomenta:
// import "dotenv/config";

import authRoutes from "./routes/authRoutes";
import appointmentRoutes from "./routes/appointmentRoutes";
import userRoutes from "./routes/userRoutes";

const app = express();

/**
 * =========================
 * CORS (ORDEN CLAVE)
 * =========================
 * - Debe ir ANTES de rutas
 * - Debe permitir:
 *   - localhost (dev)
 *   - tu Azure Static Web Apps (prod)
 *   - opcional: cualquier *.azurestaticapps.net (si cambiaste de SWA en pruebas)
 */

// Puedes poner tu URL exacta de SWA aquí (la de producción):
const STATIC_WEB_APP_ORIGIN = "https://ambitious-plant-0a172de0f.2.azurestaticapps.net";

const corsOptions: CorsOptions = {
  origin: (origin, callback) => {
    // Permitir requests sin Origin (ej: curl, health checks, algunos probes)
    if (!origin) return callback(null, true);

    const allowedExact = new Set<string>([
      "http://localhost:5173",
      "http://localhost:3000",
      STATIC_WEB_APP_ORIGIN,
    ]);

    // Permitir cualquier preview/prod de Azure Static Apps (opcional pero útil)
    const isAzureStaticApps = origin.endsWith(".azurestaticapps.net");

    if (allowedExact.has(origin) || isAzureStaticApps) {
      return callback(null, true);
    }

    return callback(new Error(`CORS bloqueado para origin: ${origin}`));
  },

  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: false, // pon true SOLO si manejas cookies/sesiones; en JWT por header normalmente es false
  optionsSuccessStatus: 204,
};

app.use(cors(corsOptions));

// Responder preflight para todas las rutas
app.options("*", cors(corsOptions));

/**
 * =========================
 * JSON Body
 * =========================
 */
app.use(express.json());

/**
 * =========================
 * Rutas
 * =========================
 */
app.use("/auth", authRoutes);
app.use("/users", userRoutes);
app.use("/appointments", appointmentRoutes);

/**
 * =========================
 * Health / Root
 * =========================
 */
app.get("/health", (_req, res) => {
  res.status(200).json({ status: "ok" });
});

app.get("/", (_req, res) => {
  res.status(200).send("API Citas Backend OK");
});

/**
 * =========================
 * Start
 * =========================
 */
const PORT = Number(process.env.PORT) || 3000;

app.listen(PORT, () => {
  console.log(`API escuchando en el puerto ${PORT}`);
});
