//
//  PostCalcTotalAmountTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/11.
//


import Foundation
import Moya

struct PostCalcTotalAmountTargetType: ApiTargetType {
    typealias Reponse = GetTotalAmountEntity

//    var baseURL: URL {
//        URL(string: "https://jy0fcsfxtj.execute-api.ap-northeast-1.amazonaws.com/guest/")!
//    }

    var baseURL: URL { URL(string: API.guestBaseURL)! }
    
    var path: String {
        "calc-total-amount"
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
    let calcTotalAmount: PostCalcTotalAmountRequestParam

    init(_ calcTotalAmount: PostCalcTotalAmountRequestParam) {
        self.calcTotalAmount = calcTotalAmount
    }
}
