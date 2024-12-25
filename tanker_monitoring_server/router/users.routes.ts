import { Router } from "express";
import {
  getDataController,
  loginController,
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

export { router };
