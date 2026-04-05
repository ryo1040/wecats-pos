//
//  CalcTotalAmountTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/11.
//

final class CalcTotalAmountTranslator {
    static func generate(calcTotalAmount: CalcTotalAmountEntity) -> CalcTotalAmountModel {
        return CalcTotalAmountModel(stayTime: calcTotalAmount.stayTime, kidsDayFlg: calcTotalAmount.kidsDayFlg, adultUnitPrice: calcTotalAmount.adultUnitPrice, adultCount: calcTotalAmount.adultCount, childUnitPrice: calcTotalAmount.childUnitPrice, childCount: calcTotalAmount.childCount, totalAmount: calcTotalAmount.totalAmount)
    }
}
