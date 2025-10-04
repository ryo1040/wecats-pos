//
//  SetDenominationTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/27.
//

import Foundation
import Moya

struct SetDenominationTargetType: ApiTargetType {
    typealias Reponse = GetDenominationEntity

    var baseURL: URL {
        URL(filePath: "https://4a42jtm29b.execute-api.ap-northeast-1.amazonaws.com/denomination/")!
    }

    var path: String {
        "set-denomination"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(postDenominationParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let postDenominationParam: PostDenominationRequestParam

    init(_ postDenominationParam: PostDenominationRequestParam) {
        self.postDenominationParam = postDenominationParam
    }
}
