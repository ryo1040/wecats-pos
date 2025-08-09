//
//  MoyaError+ErrorType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/14.
//

import Moya

protocol ErrorTypeProtocol {
    var errorType: AppError { get }
}

// MARK: - MoyaError
extension MoyaError: ErrorTypeProtocol {
    /// AppErrorを返す
    var errorType: AppError {
        let unknownClientErrorCode: Int = -1_001

        guard let response = self.response else {
            return AppError.clientError(unknownClientErrorCode)
        }

        switch response.statusCode {
        case 400:
            return AppError.badRequest(response.statusCode, apiErrorResponse(response.data))
        case 401:
            return AppError.unauthorized(response.statusCode, apiErrorResponse(response.data))
        case 408:
            return AppError.timeout
        case 500:
            return AppError.serverError(response.statusCode, apiErrorResponse(response.data))
        case 503:
            return AppError.serviceUnavailable(response.statusCode, apiErrorResponse(response.data))
        case _ where (400..<500).contains(response.statusCode):
            return AppError.clientError(response.statusCode)
        case _ where (500..<600).contains(response.statusCode):
            return AppError.serverError(response.statusCode, nil)
        default:
            return AppError.clientError(unknownClientErrorCode)
        }
    }

    private func apiErrorResponse(_ data: Data) -> APIErrorResponse? {
        do {
            let result = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            return result
        } catch {
            print("decode APIErrorResponse error:\(error)")
            return nil
        }
    }

}
