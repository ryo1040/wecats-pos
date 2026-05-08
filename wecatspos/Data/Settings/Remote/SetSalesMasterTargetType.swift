//
//  SetSalesMasterTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/08.
//

import Foundation
import Moya

struct SetSalesMasterTargetType: ApiTargetType {
    typealias Reponse = GetSalesEntity

    var baseURL: URL {
        URL(string: "https://s4e53ii5yc.execute-api.ap-northeast-1.amazonaws.com/sales/")!
    }

    var path: String {
        "set-sales-master"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(salesMaster, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let salesMaster: PostSalesMasterRequestParam

    init(_ salesMaster: PostSalesMasterRequestParam) {
        self.salesMaster = salesMaster
    }
}
