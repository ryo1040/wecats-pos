//
//  CalcTotalAmountTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/23.
//

final class CheckTotalAmountTranslator {
    static func generate(checkTotalAmountEntity: PostCheckTotalAmountEntity) -> CheckTotalAmountModel {
        
        var calcTotalModel: CheckTotalAmountModel = CheckTotalAmountModel()
        calcTotalModel = CheckTotalAmountModel(status:checkTotalAmountEntity.status, totalAmount: checkTotalAmountEntity.checkTotalAmount.totalAmount, ticketAmount: checkTotalAmountEntity.checkTotalAmount.ticketAmount, exportAmount: checkTotalAmountEntity.checkTotalAmount.exportAmount, lastDayTotalAmount: checkTotalAmountEntity.checkTotalAmount.lastDayTotalAmount, todaySales: checkTotalAmountEntity.checkTotalAmount.todaySales, checkResult: checkTotalAmountEntity.checkTotalAmount.checkResult)
        return calcTotalModel
    }
}
