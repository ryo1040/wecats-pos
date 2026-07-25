//
//  GetCareInfoTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import Foundation
import Moya

struct GetCareInfoTargetType: ApiTargetType {
    typealias Reponse = GetCareInfoEntity

//    var baseURL: URL {
//        URL(string: "https://au0rfnsgi3.execute-api.ap-northeast-1.amazonaws.com/care-info/")!
//    }
    var baseURL: URL { URL(string: API.careInfoBaseURL)! }
    
    var path: String {
        "get-care-info-list"
    }
    
    var method: Moya.Method {
        .get
    }

    var task: Task {
        return .requestParameters(parameters: ["careType": careType], encoding: URLEncoding.queryString)
    }
    
    var headers: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var careType: Int
    init(_ param: GetCareInfoRequestParam){
        self.careType = param.careType
    }
}


