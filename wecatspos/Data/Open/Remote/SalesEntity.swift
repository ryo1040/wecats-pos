//
//  SalesEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/06.
//

struct PostSalesRequestParam: Codable {
    var sales: [PostSalesRequestSales] = []
}

struct PostSalesRequestSales: Codable {
    var date: String
    var salesMasterId: Int
    var branch: Int
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case salesMasterId = "salesMasterId"
        case branch = "branch"
        case count = "count"
    }
}

public struct GetSalesEntity: Codable {
    var status: Int!
    var salesMaster: [SalesMasterEntity] = []
    var sales: [SalesEntity] = []
}

public struct SalesMasterEntity: Codable {
    var id: Int
    var name: String
    var price: Int
    var order: Int
    var memo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case order = "display_order"
        case memo = "memo"
    }
}

public struct SalesEntity: Codable {
    var date: String
    var salesMasterId: Int
    var branch: Int
    var count: Int
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case salesMasterId = "sales_master_id"
        case branch = "branch"
        case count = "count"
    }
}
