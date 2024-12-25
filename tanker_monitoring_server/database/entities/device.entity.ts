// mac address unique
// uuid
// surface area
// max height
// temprature
// turbidiry
// water_volume
// max_volume

import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity("device")
export class Device {
  @PrimaryGeneratedColumn("uuid")
  id!: String;

  @Column({ name: "device_mac_address", unique: true })
  macAddress!: String;

  @Column({ name: "surface_area" })
  surfaceArea!: number;

  @Column({ name: "max_height" })
  maxHeight!: number;

  @Column({ name: "temperature", default: 0 })
  temperature?: number;

  @Column({ name: "turbidity", default: 0 })
  turbidity?: number;

  @Column({ name: "water_level", default: 0 })
  waterLevel?: number;

  @Column({ name: "max_volume" })
  maxVolume!: number;
}
