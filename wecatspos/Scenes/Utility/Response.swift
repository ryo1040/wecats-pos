//
//  Response.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/14.
//

import Foundation
import Moya

public extension Response {

    /// アプリ独自に定義されたエラーコードを反映する
    func successfulStatusCodesPolicy() throws -> Response {
        try self.filterSuccessfulStatusAndRedirectCodes()
    }

    func filter(statusCodes: ClosedRange<Int>) throws -> Response {
        guard statusCodes.contains(statusCode) else {
            throw MoyaError.statusCode(self)
        }
        return self
    }

}
