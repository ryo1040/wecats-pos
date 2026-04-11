//
//  CheckTotalAmountTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/23.
//

import Foundation
import Moya

struct CheckTotalAmountTargetType: ApiTargetType {
    typealias Reponse = PostCheckTotalAmountEntity

    var baseURL: URL {
        URL(string: "https://i4tz3xyms2.execute-api.ap-northeast-1.amazonaws.com/close/")!
    }

    var path: String {
        "check-close-total-amount"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(calcTotalAmountParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let calcTotalAmountParam: PostCheckTotalAmountRequestParam

    init(_ calcTotalAmountParam: PostCheckTotalAmountRequestParam) {
        self.calcTotalAmountParam = calcTotalAmountParam
    }
}
