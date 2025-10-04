//
//  GetDenominationTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/27.
//

final class GetDenominationTranslator {
    static func generate(denominationEntity: GetDenominationEntity) -> [DenominationModel] {
        
        var denominationModel: [DenominationModel] = []
        for entity in denominationEntity.denominationEntity {
            let model: DenominationModel = DenominationModel(date: entity.date, branch: entity.branch, tenThousandYenCount: entity.tenThousandYenCount, fiveThousandYenCount: entity.fiveThousandYenCount, twoThousandYenCount: entity.twoThousandYenCount, oneThousandYenCount: entity.oneThousandYenCount, fiveHundredYenCount: entity.fiveHundredYenCount, oneHundredYenCount: entity.oneHundredYenCount, fiftyYenCount: entity.fiftyYenCount, tenYenCount: entity.tenYenCount, fiveYenCount: entity.fiveYenCount, oneYenCount: entity.oneYenCount, ticketCount: entity.ticketAmount, exportAmount: entity.exportAmount, totalAmount: entity.totalAmount, memo: entity.memo)
            denominationModel.append(model)
        }
        return denominationModel
    }
}
