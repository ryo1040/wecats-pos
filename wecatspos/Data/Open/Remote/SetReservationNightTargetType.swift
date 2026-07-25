//
//  SetReservationNightTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/13.
//

import Foundation
import Moya

struct SetReservationNightTargetType: ApiTargetType {
    typealias Reponse = GetGuestInfoEntity

    var baseURL: URL { URL(string: API.calcGuestBaseURL)! }
    
    var path: String {
        "set-reservation"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(reservationNightParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let reservationNightParam: PostReservationNightRequestParam

    init(_ reservationNightParam: PostReservationNightRequestParam) {
        self.reservationNightParam = reservationNightParam
    }
}
