import { Router } from "express";
import { recordReading, registerDevice } from "../controllers/device.controller";

const router = Router();

router.route("/").patch(recordReading);
router.route("/register").post(registerDevice);

export { router };
