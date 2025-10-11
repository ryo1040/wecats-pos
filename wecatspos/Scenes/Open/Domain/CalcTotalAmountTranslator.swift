//
//  CalcTotalAmountTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/11.
//

final class CalcTotalAmountTranslator {
    static func generate(calcTotalAmount: CalcTotalAmountEntity) -> CalcTotalAmountModel {
        return CalcTotalAmountModel(stayTime: calcTotalAmount.stayTime, totalAmount: calcTotalAmount.totalAmount)
    }
}
