import express from "express";
import cors, { CorsOptions } from "cors";

import authRoutes from "./routes/authRoutes";
import appointmentRoutes from "./routes/appointmentRoutes";
import userRoutes from "./routes/userRoutes";

const app = express();

/**
 * CORS (robusto para Local + Azure Static Web Apps)
 * - Responde preflight (OPTIONS)
 * - Permite origins exactos y también cualquier subdominio *.azurestaticapps.net
 */
const allowedOrigins = new Set([
  "http://localhost:5173",
  "http://localhost:3000",
  "https://ambitious-plant-0a172de0f.2.azurestaticapps.net",
]);

const corsOptions: CorsOptions = {
  origin: (origin, callback) => {
    if (!origin) return callback(null, true);

    if (allowedOrigins.has(origin) || origin.endsWith(".azurestaticapps.net")) {
      // OJO: devolver el origin explícito
      return callback(null, origin);
    }

    return callback(new Error(`CORS blocked for origin: ${origin}`));
  },
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization", "Accept", "Origin"],
};

app.use((req, res, next) => {
  res.setHeader("X-BUILD-MARK", "cors-v3");
  next();
});

// IMPORTANTE: primero CORS, luego JSON, luego rutas
app.use(cors(corsOptions));
app.options(/.*/, cors(corsOptions)); // <- responde preflight

app.use(express.json());

// Rutas
app.use("/auth", authRoutes);
app.use("/users", userRoutes);
app.use("/appointment", appointmentRoutes);

// Healthchecks
app.get("/health", (_req, res) => res.status(200).json({ status: "ok" }));
app.get("/", (_req, res) => res.status(200).send("API Citas Backend OK"));

const PORT = Number(process.env.PORT) || 3000;
app.listen(PORT, () => console.log(`API escuchando en puerto ${PORT}`));
