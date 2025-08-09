//
//  GetGuestInfoTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/07.
//

final class GetGuestInfoTranslator {
    static func generate(getGuestInfo: GetGuestInfoEntity) -> [GuestInfoModel] {
        
        var guestInfoModel: [GuestInfoModel] = []
        for entity in getGuestInfo.guestInfo {
            let model: GuestInfoModel = GuestInfoModel(id: entity.id, repeatFlag: entity.repeatFlag, patternId: entity.patternId, name: entity.name, adultCount: entity.adultCount, childCount: entity.childCount, date: entity.date, holidayFlag: entity.holidayFlag, kidsdayFlag: entity.kidsdayFlag, enterTime: entity.enterTime, leftTime: entity.leftTime, stayTime: entity.stayTime, calcAmount: entity.calcAmount, discountAmount: entity.discountAmount, salesAmount: entity.salesAmount, gachaAmount: entity.gachaAmount, totalAmount: entity.totalAmount, stayingFlag: entity.stayingFlag, memo: entity.memo)
            guestInfoModel.append(model)
        }
        return guestInfoModel
    }
}
