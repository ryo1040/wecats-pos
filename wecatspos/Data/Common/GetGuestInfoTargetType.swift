//
//  GetGuestInfoTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/15.
//

import Foundation
import Moya

struct GetGuestInfoTargetType: ApiTargetType {
    typealias Reponse = GetGuestInfoEntity

    var baseURL: URL {
        URL(filePath: "https://fhrd475n84.execute-api.ap-northeast-1.amazonaws.com/guest/")!
    }
    
    var path: String {
        "get-guest-info-day"
    }
    
    var method: Moya.Method {
        .get
    }

    var task: Task {
        return .requestParameters(parameters: ["date": date], encoding: URLEncoding.queryString)
    }
    
    var headers: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var date: String
    init(_ param: GetGuestInfoRequestParam){
        self.date = param.date
    }
}

