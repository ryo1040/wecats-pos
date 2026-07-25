//
//  GetSalesItemMaster.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/09.
//

import Foundation
import Moya

struct GetSalesMasterTargetType: ApiTargetType {
    typealias Reponse = GetSalesMasterEntity

//    var baseURL: URL {
//        URL(string: "https://s4e53ii5yc.execute-api.ap-northeast-1.amazonaws.com/sales/")!
//    }
    var baseURL: URL { URL(string: API.salesBaseURL)! }
    
    var path: String {
        "get-sales-master"
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
