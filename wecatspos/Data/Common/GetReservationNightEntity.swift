//
//  GetReservationNightEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/22.
//

// MARK: - Param
struct GetReservationNightRequestParam: Codable {
    var date: String
    var name: String
}

struct PostReservationNightRequestParam: Codable {
    var id: Int
    var branch: Int
    var reservationType: Int
    var date: String
    var name: String
    var tel: String
    var count: Int
    var price: Int
    var memo: String
    var visitorHistoryId: Int
}

struct PostDeleteReservationNightRequestParam: Codable {
    var id: Int
    var branch: Int
    var date: String
    var visitorHistoryId: Int
}

public struct GetReservationNightEntity: Codable {
    var status: Int!
    var reservationNight: [ReservationNightEntity] = []
}

public struct ReservationNightEntity: Codable {
    var id: Int
    var branch: Int
    var date: String
    var name: String
    var count: Int
    var tel: String
    var price: Int
    var memo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case branch = "branch"
        case date = "date"
        case name = "name"
        case count = "count"
        case tel = "tel"
        case price = "price"
        case memo = "memo"
    }
}
