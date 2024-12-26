// macaddress
// date
// volume

import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity("usage_history")
export class UsageHistory {
    @PrimaryGeneratedColumn("uuid")
    id!: String;

    @Column({name: "macaddress"})
    macaddress!: String;

    @Column({name: "date"})
    date!: Date;

    @Column({name: "volume", default: 0})
    volume?: number;
}