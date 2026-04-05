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

struct GetCalcTotalAmountRequestParam: Codable {
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
    var kidsDayFlg: Bool
    var adultUnitPrice: Int
    var adultCount: Int
    var childUnitPrice: Int
    var childCount: Int
    var totalAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case stayTime = "stayTime"
        case kidsDayFlg = "kidsDayFlg"
        case adultUnitPrice = "adultUnitPrice"
        case adultCount = "adultCount"
        case childUnitPrice = "childUnitPrice"
        case childCount = "childCount"
        case totalAmount = "totalAmount"
    }
}
