//
//  GetTotalAmountListTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/10.
//

final class GetTotalAmountListTranslator {
    static func generate(getTotalAmountList: GetTotalAmountListEntity) -> [TotalAmountListModel] {
        
        var totalAmountListModel: [TotalAmountListModel] = []
        for entity in getTotalAmountList.totalAmountList {
            let model: TotalAmountListModel = TotalAmountListModel(month: entity.month, date: entity.date, totalVisitors: entity.totalVisitors, totalAmount: entity.totalAmount)
            totalAmountListModel.append(model)
        }
        return totalAmountListModel
    }
}
