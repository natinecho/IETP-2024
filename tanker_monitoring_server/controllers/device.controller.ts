import { Response } from "express";
import { RegisterDeviceRequest, UpdateDeviceRequest } from "../express/DeviceRequest";
import { DeviceRepository } from "../database/repositories/device.repository";
import { Device } from "../database/entities/device.entity";

export const recordReading = async (req: UpdateDeviceRequest, res: Response) => {
  const deviceRepository = new DeviceRepository();

  const { macAddress, temperature, turbidity, waterLevel } = req.body;

  const device = await deviceRepository.findByMacAddress(macAddress);

  if (!device) {
    res.status(404).json({
      status: "fail",
      error: "Device not found.",
    });

    return;
  }

  await deviceRepository.update(macAddress, turbidity, temperature, waterLevel);
  res.status(200).json({
    status: "success",
    data: {
      mac_address: macAddress,
    },
  });
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
