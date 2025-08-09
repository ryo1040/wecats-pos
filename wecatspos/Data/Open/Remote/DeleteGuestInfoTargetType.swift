//
//  DeleteGuestInfoTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/02.
//

import Foundation
import Moya

struct DeleteGuestInfoTargetType: ApiTargetType {
    typealias Reponse = GetGuestInfoEntity

    var baseURL: URL {
        URL(filePath: "https://jy0fcsfxtj.execute-api.ap-northeast-1.amazonaws.com/guest/")!
    }

    var path: String {
        "delete-guest-info"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(guestInfoParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let guestInfoParam: PostDeleteGuestInfoRequestParam

    init(_ guestInfoParam: PostDeleteGuestInfoRequestParam) {
        self.guestInfoParam = guestInfoParam
    }
}

