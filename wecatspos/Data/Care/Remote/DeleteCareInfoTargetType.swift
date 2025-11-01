//
//  DeleteCareInfoTargetType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import Foundation
import Moya

struct DeleteCareInfoTargetType: ApiTargetType {
    typealias Reponse = GetCareInfoEntity

    var baseURL: URL {
        URL(filePath: "https://au0rfnsgi3.execute-api.ap-northeast-1.amazonaws.com/care-info/")!
    }

    var path: String {
        "delete-care-info"
    }

    var method: Moya.Method {
        .post
    }

    var task: Task {
        return .requestCustomJSONEncodable(deleteCareInfoParam, encoder: JSONEncoder())
    }

    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }

    // MARK: - Arguments
    let deleteCareInfoParam: DeleteCareInfoRequestParam

    init(_ deleteCareInfoParam: DeleteCareInfoRequestParam) {
        self.deleteCareInfoParam = deleteCareInfoParam
    }
}

