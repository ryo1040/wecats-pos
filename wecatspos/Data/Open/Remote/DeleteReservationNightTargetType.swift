//
//  DeleteReservationNightTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2026/06/20.
//

import Foundation
import Moya

struct DeleteReservationNightTargetType: ApiTargetType {
    typealias Reponse = GetGuestInfoEntity

    var baseURL: URL { URL(string: API.calcGuestBaseURL)! }
    
    var path: String {
        "delete-reservation"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(deleteRservationNightParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let deleteRservationNightParam: PostDeleteReservationNightRequestParam

    init(_ deleteRservationNightParam: PostDeleteReservationNightRequestParam) {
        self.deleteRservationNightParam = deleteRservationNightParam
    }
}
