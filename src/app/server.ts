import express from "express";
import cors from "cors";

import authRoutes from "./routes/authRoutes";
import appointmentRoutes from "./routes/appointmentRoutes";
import userRoutes from "./routes/userRoutes";

const app = express();

/**
 * IMPORTANTÍSIMO:
 * - CORS debe ir ANTES de las rutas
 * - Debe responder preflight OPTIONS
 * - En Azure App Service suele convenir "trust proxy"
 */
app.set("trust proxy", 1);

const allowedOrigins = [
  "http://localhost:5173",
  "http://localhost:3000",

  // Tu Azure Static Web Apps (producción)
  "https://ambitious-plant-0a172de0f.2.azurestaticapps.net",
];

// CORS Options
const corsOptions: cors.CorsOptions = {
  origin: (origin, callback) => {
    // Permite requests sin origin (curl/postman/healthchecks)
    if (!origin) return callback(null, true);

    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }

    // Si te sale aquí bloqueado, el origin real es distinto.
    // (En ese caso, hay que agregar el origin exacto).
    return callback(new Error(`CORS blocked for origin: ${origin}`));
  },
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: false, // true solo si usas cookies/sesión
  optionsSuccessStatus: 204,
};

// 1) CORS global
app.use(cors(corsOptions));

// 2) Responder preflight a TODO
app.options("*", cors(corsOptions));

// 3) Parsers
app.use(express.json({ limit: "1mb" }));

// 4) Health
app.get("/health", (_req, res) => {
  res.status(200).json({ status: "ok" });
});

// 5) Rutas
app.use("/auth", authRoutes);
app.use("/users", userRoutes);
app.use("/appointments", appointmentRoutes);

// 6) Root
app.get("/", (_req, res) => {
  res.status(200).send("API Citas Backend OK");
});

// 7) Error handler (útil para ver errores reales, incluyendo CORS blocked)
app.use((err: any, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error("SERVER ERROR:", err?.message || err);
  // Si el error es de CORS, lo verás aquí en logs
  res.status(500).json({ error: err?.message || "Internal server error" });
});

const PORT = process.env.PORT ? Number(process.env.PORT) : 3000;
app.listen(PORT, () => {
  console.log(`API escuchando en el puerto ${PORT}`);
});
