import { configDotenv } from "dotenv";

configDotenv();

export const ENV = {
  dbURL: process.env.DB_URL,
};
