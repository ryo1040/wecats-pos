//
//  SetMedicalHistoryTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/15.
//

import Foundation
import Moya

struct SetMedicalHistoryTargetType: ApiTargetType {
    typealias Reponse = GetMedicalHistoryEntity

    var baseURL: URL {
        URL(filePath: "https://kwwh877qvk.execute-api.ap-northeast-1.amazonaws.com/cat/")!
    }

    var path: String {
        "set-medical-history"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(medicalHistoryParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let medicalHistoryParam: PostMedicalHistoryRequestParam

    init(_ medicalHistoryParam: PostMedicalHistoryRequestParam) {
        self.medicalHistoryParam = medicalHistoryParam
    }
}
