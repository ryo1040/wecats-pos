//
//  GetSalesMasterTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/06.
//

import Foundation
import Moya

struct GetSalesMasterTargetType: ApiTargetType {
    typealias Reponse = GetSalesEntity

    var baseURL: URL {
        URL(filePath: "https://6qbn0kz550.execute-api.ap-northeast-1.amazonaws.com/sales/")!
    }
    
    var path: String {
        "get-sales-list"
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
