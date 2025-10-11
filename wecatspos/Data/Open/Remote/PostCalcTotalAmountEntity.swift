//
//  PostCalcTotalAmountEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/11.
//

struct PostCalcTotalAmountRequestParam: Codable {
    var enterTime: String
    var leftTime: String
    var adultCount: Int
    var childCount: Int
    var discountAmount: String
    var salesAmount: String
}

public struct CalcTotalAmountEntity: Codable {
    var status: Int
    var stayTime: Int
    var totalAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case stayTime = "stayTime"
        case totalAmount = "totalAmount"
    }
}
