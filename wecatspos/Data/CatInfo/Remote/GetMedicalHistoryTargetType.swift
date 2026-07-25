//
//  GetMedicalHistoryTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/11.
//

import Foundation
import Moya

struct GetMedicalHistoryTargetType: ApiTargetType {
    typealias Reponse = GetMedicalHistoryEntity

//    var baseURL: URL {
//        URL(string: "https://9bjqoyd4u2.execute-api.ap-northeast-1.amazonaws.com/cat/")!
//    }
    var baseURL: URL { URL(string: API.catBaseURL)! }
    
    var path: String {
        "get-medical-history"
    }

    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        return .requestParameters(parameters: ["catId": catId], encoding: URLEncoding.queryString)
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var catId: Int
    init(_ param: GetMedicalHistoryRequestParam){
        self.catId = param.catId
    }
}

