import "reflect-metadata";
import { DataSource } from "typeorm";
import { ENV } from "../env";

let dataSource: DataSource;

console.log(ENV.dbURL);
if (ENV.dbURL) {
  dataSource = new DataSource({
    type: "postgres",
    url: ENV.dbURL,
    ssl: true,
    database: "ietp_smart_water",
    port: 5432,
    entities: [__dirname + "/entities/**/*.{ts,js}"],
    synchronize: process.env.NODE_ENV === "production" ? false : true,
  });
} else {
  dataSource = new DataSource({
    type: "postgres",
    host: "localhost",
    username: "postgres",
    password: "root@postgres",
    database: "ietp_smart_water",
    port: 5432,
    entities: [__dirname + "/entities/**/*.ts"],
    synchronize: process.env.NODE_ENV === "production" ? false : true,
  });
}

export { dataSource };
