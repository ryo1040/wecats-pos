//
//  PostCareInfoEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

struct SetCareInfoRequestParam: Codable {
    var catId: Int
    var careType: Int
    var careDate: String
    var memo: String?
}

struct DeleteCareInfoRequestParam: Codable {
    var catId: Int
    var careType: Int
    var branch: Int
}
