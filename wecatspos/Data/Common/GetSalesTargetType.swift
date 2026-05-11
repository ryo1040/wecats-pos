//
//  GetSalesMasterTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/06.
//

import Foundation
import Moya

struct GetSalesTargetType: ApiTargetType {
    typealias Reponse = GetSalesEntity

    var baseURL: URL {
        URL(string: "https://s4e53ii5yc.execute-api.ap-northeast-1.amazonaws.com/sales/")!
    }
    
    var path: String {
        "get-sales"
    }
    
    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(date, encoder: JSONEncoder())
    }
    
    var headers: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
    
    // MARK: - Arguments
    let date: GetSalesMasterRequestParam

    init(_ date: GetSalesMasterRequestParam) {
        self.date = date
    }
}
