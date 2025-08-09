//
//  APIErrorResponse.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/14.
//

struct APIErrorResponse: Codable {
    var message: String
    var systemMessage: String?

    enum CodingKeys: String, CodingKey {
        case message
        case systemMessage = "system_message"
    }
}
