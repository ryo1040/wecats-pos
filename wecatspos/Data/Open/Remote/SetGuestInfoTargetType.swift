//
//  SetGuestInfoTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/15.
//

import Foundation
import Moya

struct SetGuestInfoTargetType: ApiTargetType {
    typealias Reponse = GetGuestInfoEntity

    var baseURL: URL {
        URL(filePath: "https://jy0fcsfxtj.execute-api.ap-northeast-1.amazonaws.com/guest/")!
    }

    var path: String {
        "set-guest-info"
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
    let guestInfoParam: PostGuestInfoRequestParam

    init(_ guestInfoParam: PostGuestInfoRequestParam) {
        self.guestInfoParam = guestInfoParam
    }
}
