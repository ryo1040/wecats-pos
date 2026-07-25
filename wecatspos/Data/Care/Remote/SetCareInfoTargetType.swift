//
//  SetCareInfoTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import Foundation
import Moya

struct SetCareInfoTargetType: ApiTargetType {
    typealias Reponse = GetCareInfoEntity

//    var baseURL: URL {
//        URL(string: "https://au0rfnsgi3.execute-api.ap-northeast-1.amazonaws.com/care-info/")!
//    }
    var baseURL: URL { URL(string: API.careInfoBaseURL)! }

    var path: String {
        "set-care-info"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(postCareInfoParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let postCareInfoParam: SetCareInfoRequestParam

    init(_ postCareInfoParam: SetCareInfoRequestParam) {
        self.postCareInfoParam = postCareInfoParam
    }
}

