//
//  GetCatInfoTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/11.
//

import Foundation
import Moya

struct GetCatInfoTargetType: ApiTargetType {
    typealias Reponse = GetCatInfoEntity

    var baseURL: URL {
//        URL(string: API.baseURL)!
        URL(filePath: "https://fflmwt4z6e.execute-api.ap-northeast-1.amazonaws.com/cat/")!
    }

    var path: String {
        "catlist"
    }

    var method: Moya.Method {
        .get
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json"
        ]
    }
    
    init(){
    }
}

