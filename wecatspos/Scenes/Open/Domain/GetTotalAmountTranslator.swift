//
//  CalcTotalAmountTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/11.
//

final class GetTotalAmountTranslator {
    static func generate(calcTotalAmount: GetTotalAmountEntity) -> GetTotalAmountModel {
        return GetTotalAmountModel(stayTime: calcTotalAmount.stayTime, kidsDayFlg: calcTotalAmount.kidsDayFlg, adultUnitPrice: calcTotalAmount.adultUnitPrice, adultCount: calcTotalAmount.adultCount, childUnitPrice: calcTotalAmount.childUnitPrice, childCount: calcTotalAmount.childCount, totalAmount: calcTotalAmount.totalAmount)
    }
}
