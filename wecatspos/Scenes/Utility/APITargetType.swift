//
//  APITargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/11.
//

import Foundation
import Moya

protocol ApiTargetType: TargetType {
    associatedtype Reponse: Codable
}

extension ApiTargetType {

    /// The target's base `URL`.
    var baseURL: URL {
        URL(string: "http://localhost:8000")!
    }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        ""
    }

    /// The HTTP method used in the request.
    var method: Moya.Method {
        .post
    }

    /// The type of HTTP task to be performed.
    var task: Task {
        .requestPlain
    }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType {
        .none
    }

    /// The headers to be used in the request.
    var headers: [String: String]? {
        nil
    }

}
