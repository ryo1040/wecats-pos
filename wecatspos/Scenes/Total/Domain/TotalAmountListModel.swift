//
//  TotalAmountInfoModel.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/10.
//

public struct TotalAmountListModel {
    public var month: String
    public var date: String
    public var totalVisitors: Int
    public var totalAmount: Int
    
    public init(month: String, date: String, totalVisitors: Int, totalAmount: Int){
        self.month = month
        self.date = date
        self.totalVisitors = totalVisitors
        self.totalAmount = totalAmount
    }
}
