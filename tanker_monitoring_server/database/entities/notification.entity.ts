import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity({ name: "notification"})
export class Notification {
    @PrimaryGeneratedColumn("uuid")
    id!: String;

    @Column({ name: "username"})
    username!: String;

    @Column({ name: "type"})
    type!: String;

    @Column({ name: "value"})
    value!: boolean;
}