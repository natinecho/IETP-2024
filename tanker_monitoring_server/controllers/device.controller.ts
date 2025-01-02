import { Response } from "express";
import { RegisterDeviceRequest, UpdateDeviceRequest } from "../express/DeviceRequest";
import { DeviceRepository } from "../database/repositories/device.repository";
import { Device } from "../database/entities/device.entity";
import { UsageHistoryRepository } from "../database/repositories/usageHistory.repository";
import { UserRepository } from "../database/repositories/user.repository";
import { NotificationRepository } from "../database/repositories/notification.repository";
import { User } from "../database/entities/user.entity";
import { Notification } from "../database/entities/notification.entity";

export const recordReading = async (req: UpdateDeviceRequest, res: Response) => {
  const userRepository = new UserRepository;
  const deviceRepository = new DeviceRepository();
  const usageHistoryRepository = new UsageHistoryRepository();

  const { macAddress, temperature, turbidity, waterLevel } = req.body;
  
  // if (!macAddress || !temperature || !turbidity || !waterLevel) {
  //   res.status(404).json({
  //     status: "fail",
  //     error: "Bad Request.",
  //   });
    
  //   return;
  // }
  
  const device = await deviceRepository.findByMacAddress(macAddress);
  
  if (!device) {
    res.status(404).json({
      status: "fail",
      error: "Device not found.",
    });
    
    return;
  }
  
  var waterVolume = device.surfaceArea * (device.maxHeight - (waterLevel / 100));

  if (waterVolume < 0) waterVolume = 0;
  else if (waterVolume > device.maxVolume) waterVolume = device.maxVolume

  const prevVolume = device.waterLevel || 0;
  
  await deviceRepository.update(macAddress, turbidity, temperature, waterVolume);
  res.status(200).json({
    status: "success",
    data: {
      mac_address: macAddress,
    },
  });

  if (! await usageHistoryRepository.getUsageHistoryToday(device.macAddress)){
    await usageHistoryRepository.add(device.macAddress);
  }
  
  if (prevVolume > waterVolume) {
    const usageHistory = await usageHistoryRepository.getUsageHistoryToday(device.macAddress);

    if (!usageHistory) return;

    usageHistory.volume -= waterVolume - prevVolume;

    await usageHistoryRepository.update(usageHistory);
  }

  const users = await userRepository.findByMacaddress(macAddress);
  
  await updateNotifications(users, device, waterVolume, turbidity);
};

async function updateNotifications(users: User[], device: Device, waterLevel: number, turbidity: number){
  const notificationRepository = new NotificationRepository();
  users.forEach(async user => {
    const checkNotifications = await notificationRepository.getNotifications(user.username);

    const notifications : Notification[] = [];
    if (checkNotifications.length < 2){
      notifications.push(new Notification());
      notifications.push(new Notification());
      notifications[0].username = user.username;
      notifications[1].username = user.username;
      notifications[0].type = "volume";
      notifications[1].type = "turbidity";
    }
    else{
      checkNotifications.forEach(n => notifications.push(n));
    }

    const minWaterVolume = device.maxVolume * (user.minWaterLevel || 30) / 100;
    const maxTurbidity = (user.minWaterQuality || 5);

    const volumeNotification = notifications.find(n => n.type == "volume");
    const turbidityNotification = notifications.find(n => n.type == "turbidity");
    
    if (volumeNotification && turbidityNotification) {
      volumeNotification.value = (waterLevel < minWaterVolume && (device.waterLevel || 0) >= minWaterVolume);
      turbidityNotification.value = (turbidity > maxTurbidity && (device.turbidity || 0) <= maxTurbidity);

      notificationRepository.setNotifications(notifications);
    }
  })
}

export const registerDevice = async (req: RegisterDeviceRequest, res: Response) => {
  const deviceRepository = new DeviceRepository();

  const { macAddress, maxHeight, surfaceArea } = req.body;

  const checkDevice = await deviceRepository.findByMacAddress(macAddress ?? "");

  if (checkDevice || macAddress.trim() === "" || !maxHeight || !surfaceArea) {
    res.status(404).json({
      status: "fail",
      error: "Device already registered.",
    });

    return;
  }

  const device = new Device();
  device.maxVolume = maxHeight * surfaceArea;
  device.maxHeight = maxHeight;
  device.surfaceArea = surfaceArea;
  device.macAddress = macAddress;

  const deviceRg = await deviceRepository.register(device);

  if (!deviceRg) {
    res.status(404).json({
      status: "fail",
      error: "Device not registered.",
    });

    return;
  }

  res.status(200).json({
    status: "success",
    data: {
      device: deviceRg,
    },
  });
};
