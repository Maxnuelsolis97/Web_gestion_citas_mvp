import express from "express";
import cors from "cors";

import authRoutes from "./routes/authRoutes";
import appointmentRoutes from "./routes/appointmentRoutes";
import userRoutes from "./routes/userRoutes";

const app = express();

/* ===============================
   CORS – CONFIGURACIÓN CORRECTA
   =============================== */

const allowedOrigins = [
  "http://localhost:5173",
  "http://localhost:3000",
  "https://ambitious-plant-0a172de0f.2.azurestaticapps.net",
];

app.use(
  cors({
    origin: function (origin, callback) {
      // Permitir llamadas sin origin (Postman, health checks)
      if (!origin) return callback(null, true);

      if (allowedOrigins.includes(origin)) {
        return callback(null, true);
      }

      return callback(new Error("Not allowed by CORS"));
    },
    credentials: true,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

// 🔴 ESTO ES CLAVE (preflight)
app.options("*", cors());

/* ===============================
   MIDDLEWARES
   =============================== */

app.use(express.json());

/* ===============================
   RUTAS
   =============================== */

app.use("/auth", authRoutes);
app.use("/users", userRoutes);
app.use("/appointment", appointmentRoutes);

app.get("/health", (_req, res) => {
  res.status(200).json({ status: "ok" });
});

app.get("/", (_req, res) => {
  res.status(200).send("API Citas Backend OK");
});

/* ===============================
   SERVER
   =============================== */

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`API escuchando en puerto ${PORT}`);
});
