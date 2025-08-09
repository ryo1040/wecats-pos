//
//  GetMedicalHistoryEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/02.
//

struct GetMedicalHistoryRequestParam: Codable {
    var catId: Int
}

public struct GetMedicalHistoryEntity: Codable {
    var status: Int
    var medicalHistory: [MedicalHistoryEntity]
    
    enum CodingKeys: String, CodingKey {
        case status
        case medicalHistory
    }
}

public struct MedicalHistoryEntity: Codable {
    var id: Int
    var catId: Int
    var date: String
    var reason: String
    var treatment: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case catId = "cat_id"
        case date = "date"
        case reason = "reason"
        case treatment = "treatment"
        case createdAt = "created_at"
    }
}
