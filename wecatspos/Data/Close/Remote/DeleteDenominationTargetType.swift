//
//  DeleteDenominationTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/09/20.
//

import Foundation
import Moya

struct DeleteDenominationTargetType: ApiTargetType {
    typealias Reponse = GetDenominationEntity

    var baseURL: URL {
        URL(string: "https://4a42jtm29b.execute-api.ap-northeast-1.amazonaws.com/denomination/")!
    }

    var path: String {
        "delete-denomination"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(deleteDenominationParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let deleteDenominationParam: PostDenominationDeleteRequestParam

    init(_ deleteDenominationParam: PostDenominationDeleteRequestParam) {
        self.deleteDenominationParam = deleteDenominationParam
    }
}
