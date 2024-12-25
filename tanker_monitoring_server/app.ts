import express, { Express, json } from "express";
import { router as deviceRouter } from "./router/devices.routes";
import { router as userRouter } from "./router/users.routes";
import cors from "cors";

const app: Express = express();
app.use(cors());
app.use(json());

app.use("/device", deviceRouter);
app.use("/user", userRouter);

export { app };
