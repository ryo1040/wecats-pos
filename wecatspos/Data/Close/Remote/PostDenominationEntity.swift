//
//  PostDenominationEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/23.
//

struct PostDenominationRequestParam: Codable {
    var date: String
    var tenThousandYenCount: Int
    var fiveThousandYenCount: Int
    var twoThousandYenCount: Int
    var oneThousandYenCount: Int
    var fiveHundredYenCount: Int
    var oneHundredYenCount: Int
    var fiftyYenCount: Int
    var tenYenCount: Int
    var fiveYenCount: Int
    var oneYenCount: Int
    var exportAmount: Int
    var ticketAmount: Int
    var totalAmount: Int
    var memo: String?
}

struct PostCheckTotalAmountRequestParam: Codable {
    var date: String
    var totalAmount: Int
    var ticketAmount: Int
    var exportAmount: Int
}

struct PostDenominationDeleteRequestParam: Codable {
    var date: String
}

public struct PostCheckTotalAmountEntity: Codable {
    var status: Int!
    var checkTotalAmount: CheckTotalAmountEntity = CheckTotalAmountEntity(totalAmount: -1, ticketAmount: -1, exportAmount: -1, lastDayTotalAmount: -1, todaySales: -1, checkResult: "")
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case checkTotalAmount = "checkTotalAmount"
    }
}

public struct CheckTotalAmountEntity: Codable {
    var totalAmount: Int
    var ticketAmount: Int
    var exportAmount: Int
    var lastDayTotalAmount: Int
    var todaySales: Int
    var checkResult: String
    
    enum CodingKeys: String, CodingKey {
        case totalAmount = "totalAmount"
        case ticketAmount = "ticketAmount"
        case exportAmount = "exportAmount"
        case lastDayTotalAmount = "lastDayTotalAmount"
        case todaySales = "todaySales"
        case checkResult = "checkResult"
    }
}


