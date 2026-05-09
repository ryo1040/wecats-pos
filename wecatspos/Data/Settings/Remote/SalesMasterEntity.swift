//
//  SalesMasterEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/09.
//

struct PostSalesMasterRequestParam: Codable {
    var id: Int
    var branch: Int
    var name: String
    var price: Int
    var order: Int
    var memo: String
}

public struct GetSalesMasterEntity: Codable {
    var status: Int!
    var salesMaster: [SalesMasterEntity] = []
}

public struct SalesMasterEntity: Codable {
    var id: Int
    var branch: Int
    var name: String
    var price: Int
    var order: Int
    var memo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case branch = "branch"
        case name = "name"
        case price = "price"
        case order = "display_order"
        case memo = "memo"
    }
}
