// email
// username unique
// device_mac_address
// password

import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { Device } from "./device.entity";

@Entity("user")
export class User {
  @PrimaryGeneratedColumn("uuid")
  id!: String;

  @Column({ name: "password" })
  password!: String;

  @Column({ name: "username", unique: true })
  username!: String;

  @Column({ name: "min_water_level", default: 30 })
  minWaterLevel?: number;

  @Column({ name: "min_water_quality", default: 30 })
  minWaterQuality?: number;

  @ManyToOne(() => Device, (device: Device) => device.macAddress)
  @JoinColumn({ name: "mac_address" })
  device!: Device;

  @Column({ name: "mac_address" })
  macAddress!: String;
}
