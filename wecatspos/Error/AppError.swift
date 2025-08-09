//
//  AppError.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/14.
//

enum AppError: Error {
    // MARK: - Request/Client Error
    case offline
    case timeout
    case clientError(Int)
    case badRequest(Int, APIErrorResponse?) //400
    case unauthorized(Int, APIErrorResponse?) //401

    // MARK: - Server Error
    case serverError(Int, APIErrorResponse?) //500
    case serviceUnavailable(Int, APIErrorResponse?) //503

    // MARK: - Application Error
    case noData
    case duplicate // 重複
    case limit // 上限超え

    // MARK: - Others
    case generic
    case location

    var appErrorType: AppErrorTypeProtocol {
        switch self {
        case .offline:
            return NetworkError("Offline")
        case .timeout:
            return NetworkError("TimeOut")
        case .clientError(let statusCode):
            return NetworkError(String(statusCode))
        case let .badRequest(statusCode, response):
            return BadRequestError(String(statusCode), response)
        case let .unauthorized(statusCode, response):
            return UnauthorizedError(String(statusCode), response)
        case let .serverError(statusCode, response):
            return ServerError(String(statusCode), response)
        case let .serviceUnavailable(statusCode, response):
            return MaintenanceError(String(statusCode), response)
        case .duplicate:
            return SystemError("Duplicate")
        case .limit:
            return SystemError("Limit")
        case .noData:
            return SystemError("No Data")
        case .generic:
            return SystemError("Unknown")
        case .location:
            return SystemError("Location")
        }
    }
}

extension Error {
    var asAppError: AppError? {
        self as? AppError
    }
}
