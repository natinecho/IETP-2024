import { dataSource } from "./database/datasource";

const init = async () => {
  try {
    await dataSource.initialize();

    console.log("DB Connected.");
  } catch (err) {
    console.log(err);
  }
};

export const typeorm = {
  init,
};
