import express from "express";
import cors from "cors";

import authRoutes from "./routes/authRoutes";
import appointmentRoutes from "./routes/appointmentRoutes";
import userRoutes from "./routes/userRoutes";

const app = express();

/* =========================
   MIDDLEWARES (ORDEN CLAVE)
   ========================= */

app.use(cors({
  origin: [
    "http://localhost:5173",
    "http://localhost:3000",
    "https://ambitious-plant-0a172de0f.2.azurestaticapps.net",
  ],
  methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));

app.use(express.json());

/* =========================
   RUTAS
   ========================= */

app.use("/auth", authRoutes);
app.use("/users", userRoutes);
app.use("/appointments", appointmentRoutes);

app.get("/health", (_req, res) => {
  res.status(200).json({ status: "ok" });
});

app.get("/", (_req, res) => {
  res.status(200).send("API Citas Backend OK");
});

/* =========================
   SERVER
   ========================= */

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`API escuchando en el puerto ${PORT}`);
});
