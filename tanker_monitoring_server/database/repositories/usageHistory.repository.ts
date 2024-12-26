import { dataSource } from "../datasource"
import { UsageHistory } from "../entities/usageHistory.entity"

export class UsageHistoryRepository {
    private usageHistoryRepo = dataSource.getRepository(UsageHistory);

    public async add(macAddress: String){
        const usageHistory = new UsageHistory();
        usageHistory.macaddress = macAddress;
        usageHistory.date = new Date();
        usageHistory.date.setHours(3, 0, 0, 0);
        return await this.usageHistoryRepo.save(usageHistory);
    }

    public async update(usageHistory: UsageHistory){
        return await this.usageHistoryRepo.save(usageHistory);
    }

    public async getUsageHistoryToday(macAddress: String){
        const today = new Date();
        today.setHours(3, 0, 0, 0);
        return await this.usageHistoryRepo.findOne({
            where: {
                macaddress: macAddress,
                date: today
            }
        });
    }

    public async getUsageHistory(macAddress: String){
        return await this.usageHistoryRepo.find({
            where: {
                macaddress: macAddress
            },
            take: 30
        });
    }
}
