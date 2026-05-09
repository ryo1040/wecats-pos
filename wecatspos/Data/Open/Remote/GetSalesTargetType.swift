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
