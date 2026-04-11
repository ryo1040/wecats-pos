//
//  CalcTotalAmountModel.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/11.
//

public struct CalcTotalAmountModel {
    public var stayTime: Int
    public var kidsDayFlg: Bool
    public var adultUnitPrice: Int
    public var adultCount: Int
    public var childUnitPrice: Int
    public var childCount: Int
    public var totalAmount: Int

    public init(stayTime: Int, kidsDayFlg: Bool, adultUnitPrice: Int, adultCount: Int, childUnitPrice: Int, childCount: Int, totalAmount: Int) {
        self.stayTime = stayTime
        self.kidsDayFlg = kidsDayFlg
        self.adultUnitPrice = adultUnitPrice
        self.adultCount = adultCount
        self.childUnitPrice = childUnitPrice
        self.childCount = childCount
        self.totalAmount = totalAmount
    }
    
    public init() {
        self.stayTime = -1
        self.kidsDayFlg = false
        self.adultUnitPrice = -1
        self.adultCount = -1
        self.childUnitPrice = -1
        self.childCount = -1
        self.totalAmount = -1
    }
}
