import { dataSource } from "../datasource";
import { Device } from "../entities/device.entity";

export class DeviceRepository {
  private deviceRepo = dataSource.getRepository(Device);
  public async findByMacAddress(macAddress: String) {
    return await this.deviceRepo.findOneBy({ macAddress });
  }

  public async update(macAddress: String, turbidity: number, temperature: number, waterLevel: number) {
    const device = await this.findByMacAddress(macAddress);

    if (!device) return;

    device.turbidity = turbidity;
    device.temperature = temperature;
    device.waterLevel = waterLevel;

    this.deviceRepo.save(device);
  }

  public async register(device: Device) {
    return await this.deviceRepo.save(device);
  }
}
