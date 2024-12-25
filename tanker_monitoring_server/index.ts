import { app } from "./app";
import { typeorm } from "./typeorm";

typeorm.init();

app.listen(3000, () => {
  console.log("App is up and running.");
});
