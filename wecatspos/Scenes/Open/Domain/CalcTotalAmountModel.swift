//
//  CalcTotalAmountModel.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/11.
//

public struct CalcTotalAmountModel {
    public var stayTime: Int
    public var totalAmount: Int

    public init(stayTime: Int, totalAmount: Int){
        self.stayTime = stayTime
        self.totalAmount = totalAmount
    }
    
    public init() {
        self.stayTime = -1
        self.totalAmount = -1
    }
}
