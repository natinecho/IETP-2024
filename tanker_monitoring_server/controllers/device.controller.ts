import { Response } from "express";
import { RegisterDeviceRequest, UpdateDeviceRequest } from "../express/DeviceRequest";
import { DeviceRepository } from "../database/repositories/device.repository";
import { Device } from "../database/entities/device.entity";
import { UsageHistoryRepository } from "../database/repositories/usageHistory.repository";

export const recordReading = async (req: UpdateDeviceRequest, res: Response) => {
  const deviceRepository = new DeviceRepository();
  const usageHistoryRepository = new UsageHistoryRepository();

  const { macAddress, temperature, turbidity, waterLevel } = req.body;

  if (!macAddress || !temperature || !turbidity || !waterLevel) {
    res.status(404).json({
      status: "fail",
      error: "Bad Request.",
    });

    return;
  }

  const device = await deviceRepository.findByMacAddress(macAddress);

  if (!device) {
    res.status(404).json({
      status: "fail",
      error: "Device not found.",
    });

    return;
  }
  
  const waterVolume = device.surfaceArea * (device.maxHeight - waterLevel);

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

    usageHistory.volume = (usageHistory.volume || 0) + prevVolume - waterVolume;

    await usageHistoryRepository.update(usageHistory);
  }
};

export const registerDevice = async (req: RegisterDeviceRequest, res: Response) => {
  const deviceRepository = new DeviceRepository();

  const { macAddress, maxHeight, surfaceArea } = req.body;

  const checkDevice = await deviceRepository.findByMacAddress(macAddress ?? "");

  if (checkDevice || macAddress.trim() === "" || !maxHeight || !surfaceArea) {
    res.status(404).json({
      status: "fail",
      error: "Device not registered.",
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
