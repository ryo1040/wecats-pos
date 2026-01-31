//
//  GetCareInfoEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

struct GetCareInfoRequestParam: Codable {
    var careType: Int
}

public struct GetCareInfoEntity: Codable {
    var status: Int
    var careInfoEntity: [CareInfoEntity]
}

public struct CareInfoEntity: Codable {
    var catId: Int
    var catName: String
    var careType: Int
    var branch: Int
    var careDate: String
    var memo: String?
    
    enum CodingKeys: String, CodingKey {
        case catId = "cat_id"
        case catName = "cat_name"
        case careType = "care_type"
        case branch = "branch"
        case careDate = "care_date"
        case memo = "memo"
    }
}
