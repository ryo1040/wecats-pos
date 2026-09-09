//
//  GetCalcTotalAmountTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/04.
//

import Foundation
import Moya

struct GetCalcTotalAmountTargetType: ApiTargetType {
    typealias Reponse = GetTotalAmountEntity

//    var baseURL: URL {
//        URL(string: "https://vl1sxpjk81.execute-api.ap-northeast-1.amazonaws.com/guest/")!
//    }

    var baseURL: URL { URL(string: API.calcGuestBaseURL)! }
    
    var path: String {
        "get-total-amount"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(calcTotalAmount, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let calcTotalAmount: GetCalcTotalAmountRequestParam

    init(_ calcTotalAmount: GetCalcTotalAmountRequestParam) {
        self.calcTotalAmount = calcTotalAmount
    }
}
