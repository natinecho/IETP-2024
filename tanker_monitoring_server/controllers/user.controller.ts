import { Request, Response } from "express";
import { UserRepository } from "../database/repositories/user.repository";
import {
  UserLoginRequest,
  UserRegisterRequest,
  UserUpdatePasswordRequest,
  UserUpdatePreferencesRequest,
} from "../express/UserRequest";
import { DeviceRepository } from "../database/repositories/device.repository";
import { User } from "../database/entities/user.entity";
import { UsageHistoryRepository } from "../database/repositories/usageHistory.repository";
import { NotificationRepository } from "../database/repositories/notification.repository";
import { UsageHistory } from "../database/entities/usageHistory.entity";

// water_level_notification_preference
// water_quality_notification_preference

export const registerUserController = async (req: UserRegisterRequest, res: Response) => {
  const userRepository = new UserRepository();
  const deviceRepository = new DeviceRepository();

  const { macAddress, username, password } = req.body;

  const device = await deviceRepository.findByMacAddress(macAddress);

  if (username == "" || !device) {
    res.status(404).json({
      status: "fail",
      message: "No device with this mac address.",
    });

    return;
  }

  const user = await userRepository.findByUsername(username);

  if (user) {
    res.status(404).json({
      status: "fail",
      message: "User already registered.",
    });

    return;
  }

  const userObj = new User();
  userObj.device = device;
  userObj.username = username;
  userObj.password = password;

  const userRg = await userRepository.register(userObj);

  if (!userRg) {
    res.status(404).json({
      status: "fail",
      message: "User not registered.",
    });

    return;
  }

  res.status(200).json({
    status: "success",
    body: {
      user: userRg,
    },
  });
};

export const loginController = async (req: UserLoginRequest, res: Response) => {
  const userRepository = new UserRepository();

  const user = await userRepository.findByUsername(req.body.username);

  if (!user) {
    res.status(404).json({
      status: "fail",
      message: "Wrong username or password 1",
    });
    return;
  }

  if (user.password != req.body.password) {
    res.status(404).json({
      status: "fail",
      message: "Wrong username or password 2",
    });

    return;
  }

  res.status(200).json({
    status: "success",
    message: "User has logged in.",
  });
};

export const getDataController = async (req: Request, res: Response) => {
  const userRepository = new UserRepository();

  const username = req.params.username;

  if (!username) {
    res.status(400).json({
      status: "fail",
      message: "Bad Request.",
    });

    return;
  }

  const user = await userRepository.findByUsername(username);

  if (!user) {
    res.status(404).json({
      status: "fail",
      message: "User not found.",
    });

    return;
  }

  const device = user.device;

  if (!device) {
    res.status(404).json({
      status: "fail",
      message: "Device not found.",
    });

    return;
  }

  res.status(200).json({
    status: "success",
    data: {
      user,
    },
  });
};

export const updatePreferencesController = async (req: UserUpdatePreferencesRequest, res: Response) => {
  const userRepository = new UserRepository();
  const { username, minLevel, minQuality } = req.body;

  const user = await userRepository.findByUsername(username ?? "");

  if (!user) {
    res.status(404).json({
      status: "fail",
      message: "User not found.",
    });

    return;
  }

  if (minLevel > 100 || minLevel <= 0 || minQuality > 100 || minQuality <= 0) {
    res.status(404).json({
      status: "fail",
      message: "Preferences not updated.",
    });

    return;
  }

  user.minWaterLevel = minLevel;
  user.minWaterQuality = minQuality;

  const userRg = await userRepository.update(user);

  if (!userRg) {
    res.status(404).json({
      status: "fail",
      message: "User not updated.",
    });

    return;
  }

  res.status(200).json({
    status: "success",
    body: {
      user: userRg,
    },
  });
};

export const updatePasswordController = async (req: UserUpdatePasswordRequest, res: Response) => {
  const userRepository = new UserRepository();
  const { username, password, newPassword } = req.body;

  const user = await userRepository.findByUsername(username ?? "");
  if (!user) {
    res.status(400).json({
      status: "fail",
      message: "User not found.",
    });

    return;
  }

  if (user.password !== password) {
    res.status(400).json({
      status: "fail",
      message: "Who are u trying to cheat?",
    });

    return;
  }

  user.password = newPassword;

  const userRg = await userRepository.update(user);

  if (!userRg) {
    res.status(404).json({
      status: "fail",
      message: "User not updated.",
    });

    return;
  }

  res.status(200).json({
    status: "success",
    body: {
      user: userRg,
    },
  });
};

export const notificationController = async (req: Request, res: Response) => {
  const userRepository = new UserRepository();
  const notificationRepository = new NotificationRepository();

  const username = req.params.username

  const user = await userRepository.findByUsername(username ?? "");
  if (!user) {
    res.status(400).json({
      status: "fail",
      message: "User not found.",
    });

    return;
  }

  const device = user.device;

  if (!device) {
    res.status(404).json({
      status: "fail",
      message: "Device not found.",
    });

    return;
  }

  const notifications = await notificationRepository.getNotifications(username);

  const waterLevelNotification = notifications.find((n) => n.type == "volume")?.value;
  const turbidityNotification = notifications.find((n) => n.type == "turbidity")?.value;

  res.status(200).json({
    status: "success",
    body: {
      waterLevelNotification,
      turbidityNotification
    }
  })
}

export const usageHistoryController = async (req: Request, res: Response) => {
  const userRepository = new UserRepository();
  const usageHistoryRepository = new UsageHistoryRepository();

  const username = req.params.username;

  if (!username || username.trim() == "") {
    res.status(404).json({
      status: "fail",
      message: "Bad Request!"
    });

    return;
  }

  const user = await userRepository.findByUsername(username);

  if (!user) {
    res.status(404).json({
      status: "fail",
      message: "User not Found"
    });

    return;
  }

  const usageHistory: UsageHistory[] = [];
  (await usageHistoryRepository.getUsageHistory(user.device.macAddress)).forEach((history) => usageHistory.unshift(history));

  res.status(200).json({
    status: "success",
    body: {
      usageHistory
    }
  });
}
