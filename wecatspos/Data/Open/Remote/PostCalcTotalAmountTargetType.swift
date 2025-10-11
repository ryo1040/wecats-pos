//
//  PostCalcTotalAmountTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/11.
//


import Foundation
import Moya

struct PostCalcTotalAmountTargetType: ApiTargetType {
    typealias Reponse = CalcTotalAmountEntity

    var baseURL: URL {
        URL(filePath: "https://jy0fcsfxtj.execute-api.ap-northeast-1.amazonaws.com/guest/")!
    }

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
