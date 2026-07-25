//
//  SetSalesTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/11.
//

import Foundation
import Moya

struct SetSalesTargetType: ApiTargetType {
    typealias Reponse = GetSalesEntity

//    var baseURL: URL {
//        URL(string: "https://s4e53ii5yc.execute-api.ap-northeast-1.amazonaws.com/sales/")!
//    }
    var baseURL: URL { URL(string: API.salesBaseURL)! }

    var path: String {
        "set-sales"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(sales, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let sales: PostSalesRequestParam

    init(_ sales: PostSalesRequestParam) {
        self.sales = sales
    }
}
