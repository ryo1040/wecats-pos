//
//  GetGuestInfo.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/07.
//

// MARK: - Param
struct PostGuestInfoRequestParam: Codable {
    var id: Int
    var repeatFlag: Bool
    var patternId: Int
    var name: String
    var date: String
    var holidayFlag: Bool
    var kidsDayFlag: Bool
    var enterTime: String
    var leftTime: String
    var stayTime: Int
    var adultCount: Int
    var childCount: Int
    var calcAmount: Int
    var discountAmount: Int
    var salesAmount: Int
    var gachaAmount: Int
    var totalAmount: Int
    var stayingFlag: Bool
    var memo: String
}

struct GetGuestInfoRequestParam: Codable {
    var date: String
}

struct PostDeleteGuestInfoRequestParam: Codable {
    var id: Int
    var date: String
}

public struct GetGuestInfoEntity: Codable {
    var status: Int!
    var guestInfo: [GuestInfoEntity] = []
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case guestInfo = "guestInfo"
    }
}

public struct GuestInfoEntity: Codable {
    var id: Int
    var repeatFlag: Bool
    var patternId: Int
    var name: String?
    var adultCount: Int
    var childCount: Int
    var date: String
    var holidayFlag: Bool
    var kidsdayFlag: Bool
    var enterTime: String
    var leftTime: String
    var stayTime: Int
    var calcAmount: Int
    var discountAmount: Int
    var salesAmount: Int
    var gachaAmount: Int
    var totalAmount: Int
    var stayingFlag: Bool
    var memo: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case repeatFlag = "repeat_flg"
        case patternId = "pattern_id"
        case name = "name"
        case adultCount = "adult_count"
        case childCount = "child_count"
        case date = "date"
        case holidayFlag = "holiday_flg"
        case kidsdayFlag = "kidsday_flg"
        case enterTime = "enter_time"
        case leftTime = "left_time"
        case stayTime = "stay_time"
        case calcAmount = "calc_amount"
        case discountAmount = "discount_amount"
        case salesAmount = "sales_amount"
        case gachaAmount = "gacha_amount"
        case totalAmount = "total_amount"
        case memo = "memo"
        case stayingFlag = "staying_flg"
    }
}
