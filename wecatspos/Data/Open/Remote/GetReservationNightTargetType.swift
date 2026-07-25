//
//  GetReservationNightTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/22.
//

import Foundation
import Moya

struct GetReservationNightTargetType: ApiTargetType {
    typealias Reponse = GetReservationNightEntity

    var baseURL: URL { URL(string: API.calcGuestBaseURL)! }

    var path: String {
        "get-reservation-night-info"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(getReservationNightParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let getReservationNightParam: GetReservationNightRequestParam

    init(_ getReservationNightParam: GetReservationNightRequestParam) {
        self.getReservationNightParam = getReservationNightParam
    }
}
