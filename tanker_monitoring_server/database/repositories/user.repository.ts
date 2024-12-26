import { dataSource } from "../datasource";
import { User } from "../entities/user.entity";

export class UserRepository {
  private userRepo = dataSource.getRepository(User);

  public async register(user: User) {
    return await this.userRepo.save(user);
  }

  public async findByUsername(username: String) {
    return await this.userRepo.findOne({
      where: {
        username: username,
      },
      relations: ["device"],
    });
  }

  public async update(user: User) {
    return await this.userRepo.save(user);
  }
}
