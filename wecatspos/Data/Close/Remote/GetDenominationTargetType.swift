//
//  GetDenominationTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/27.
//

import Foundation
import Moya

struct GetDenominationTargetType: ApiTargetType {
    typealias Reponse = GetDenominationEntity

//    var baseURL: URL {
//        URL(string: "https://4a42jtm29b.execute-api.ap-northeast-1.amazonaws.com/denomination/")!
//    }
    var baseURL: URL { URL(string: API.denominationBaseURL)! }
    
    var path: String {
        "get-denomination-list"
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
    init(_ param: GetDenominationRequestParam){
        self.month = param.month
    }
}

