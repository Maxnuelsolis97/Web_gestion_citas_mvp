import express from "express";
import authRoutes from "./routes/authRoutes";
import appointmentRoutes from "./routes/appointmentRoutes";

const app = express();
app.use(express.json());

//Rutas
import userRoutes from "./routes/userRoutes";
app.use("/users", userRoutes);

app.use("/appointments", appointmentRoutes);

app.use("/auth", authRoutes);
// Endpoint de prueba
app.get("/health", (_req, res) => {
  res.json({ status: "ok" });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`API escuchando en el puerto ${PORT}`);
});
