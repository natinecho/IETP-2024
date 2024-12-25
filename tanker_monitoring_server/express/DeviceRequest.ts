import { Request } from "express";
import { Device } from "../database/entities/device.entity";

export interface UpdateDeviceRequest extends Request {
  body: {
    macAddress: String;
    turbidity: number;
    temperature: number;
    waterLevel: number;
  };
}

export interface RegisterDeviceRequest extends Request {
  body: {
    macAddress: String;
    maxHeight: number;
    surfaceArea: number;
  };
}
