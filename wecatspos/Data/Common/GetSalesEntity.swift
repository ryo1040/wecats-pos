//
//  SalesEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/06.
//

struct GetSalesMasterRequestParam: Codable {
    var date: String
}

struct PostSalesRequestParam: Codable {
    var sales: [PostSalesRequestSales] = []
    var totalAmount: Int
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
