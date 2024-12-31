import { dataSource } from "../datasource";
import { Notification } from "../entities/notification.entity";

export class NotificationRepository {
    private notificationRepo = dataSource.getRepository(Notification);

    public async getNotifications(username: String){
        return await this.notificationRepo.find({
            where: {
                username: username
            }
        });
    }

    public async setNotifications(notifications: Notification[]){
        return await this.notificationRepo.save(notifications);
    }
}