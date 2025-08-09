//
//  TotalAmountListEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/10.
//

struct GetTotalAmountListRequestParam: Codable {
    var month: String
}

public struct GetTotalAmountListEntity: Codable {
    var status: Int!
    var totalAmountList: [TotalAmountListEntity] = []
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case totalAmountList = "totalAmountList"
    }
}

public struct TotalAmountListEntity: Codable {
    var month: String
    var date: String
    var totalVisitors: Int
    var totalAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case month = "month"
        case date = "date"
        case totalVisitors = "total_visitors"
        case totalAmount = "total_amount"
    }
}
