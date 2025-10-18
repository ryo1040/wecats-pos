//
//  GetDenominationEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/20.
//

struct GetDenominationRequestParam: Codable {
    var month: String
}

public struct GetDenominationEntity: Codable {
    var status: Int
    var denominationEntity: [DenominationEntity]
}

public struct DenominationEntity: Codable {
    var date: String
    var branch: Int
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
    var ticketAmount: Int
    var exportAmount: Int
    var totalAmount: Int
    var memo: String?
    var dailySalesAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case branch = "branch"
        case tenThousandYenCount = "tenthousandyen_count"
        case fiveThousandYenCount = "fivethousandyen_count"
        case twoThousandYenCount = "twothousandyen_count"
        case oneThousandYenCount = "onethousandyen_count"
        case fiveHundredYenCount = "fivehundredyen_count"
        case oneHundredYenCount = "onehundredyen_count"
        case fiftyYenCount = "fiftyyen_count"
        case tenYenCount = "tenyen_count"
        case fiveYenCount = "fiveyen_count"
        case oneYenCount = "oneyen_count"
        case ticketAmount = "ticket_amount"
        case exportAmount = "export_amount"
        case totalAmount = "total_amount"
        case memo = "memo"
        case dailySalesAmount = "daily_sales_amount"
    }
}
