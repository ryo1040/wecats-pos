//
//  GetTotalAmountListTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/17.
//

import Foundation
import Moya

struct GetTotalAmountListTargetType: ApiTargetType {
    typealias Reponse = GetTotalAmountListEntity

    var baseURL: URL {
        URL(filePath: "https://2h7b8vpz13.execute-api.ap-northeast-1.amazonaws.com/guest/")!
    }
    
    var path: String {
        "get-guest-info-month"
    }
    
    var method: Moya.Method {
        .get
    }

    var task: Task {
        return .requestParameters(parameters: ["month": month], encoding: URLEncoding.queryString)
    }
    
    var headers: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var month: String
    init(_ param: GetTotalAmountListRequestParam){
        self.month = param.month
    }
}

