//
//  PostMedicalHistoryEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/03.
//

// MARK: - Param
struct PostMedicalHistoryRequestParam: Codable {
    var id: Int
    var catId: Int
    var date: String
    var reason: String
    var treatment: String
}

// MARK: - Entities
public struct PostMedicalHistoryEntity: Codable {
    var status: Int

    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}
