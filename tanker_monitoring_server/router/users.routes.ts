import { Router } from "express";
import {
  getDataController,
  loginController,
  notificationController,
  registerUserController,
  updatePasswordController,
  updatePreferencesController,
} from "../controllers/user.controller";

const router = Router();

router.route("/login").post(loginController);
router.route("/signup").post(registerUserController);
router.route("/").patch(updatePreferencesController);
router.route("/:username").get(getDataController);
router.route("/update-password").patch(updatePasswordController);
router.route("/notification").post(notificationController);

export { router };