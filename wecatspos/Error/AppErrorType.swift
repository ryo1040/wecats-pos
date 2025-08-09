//
//  AppErrorType.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/14.
//

struct NetworkError: AppErrorTypeProtocol {
    var errorCode: String = ""
    var title: String = ""
    var message: String = ""
    var userResponses: [AppErrorUserOption] {
        return [.retry]
    }
    var cancelUserResponse: AppErrorUserOption?

    init(_ errorCode: String) {
        self.errorCode = errorCode
        self.message = errorMessageWithErrorCode(message: "ネットワークエラーが発生しました。", errorCode: errorCode)
    }
}

struct BadRequestError: AppErrorTypeProtocol {
    var errorCode: String = ""
    var title: String = ""
    var message: String = "予期せぬエラーが発生しました（400）"
    var userResponses: [AppErrorUserOption] {
        return [.ok]
    }
    var cancelUserResponse: AppErrorUserOption?

    init(_ errorCode: String, _ response: APIErrorResponse?) {
        self.errorCode = errorCode
        if let response = response {
            self.message = response.message
        }
    }
}

struct UnauthorizedError: AppErrorTypeProtocol {
    var errorCode: String = ""
    var title: String = ""
    var message: String = "予期せぬエラーが発生しました(401)"
    var userResponses: [AppErrorUserOption] {
        return [.ok]
    }
    var cancelUserResponse: AppErrorUserOption?

    init(_ errorCode: String, _ response: APIErrorResponse?) {
        self.errorCode = errorCode
        if let response = response {
            self.message = response.message
        }
    }
}

struct ServerError: AppErrorTypeProtocol {
    var errorCode: String = ""
    var title: String = ""
    var message: String = "サーバエラーが発生しました。"
    var userResponses: [AppErrorUserOption] {
        return [.ok]
    }
    var cancelUserResponse: AppErrorUserOption?

    init(_ errorCode: String, _ response: APIErrorResponse?) {
        self.errorCode = errorCode
        if let response = response {
            self.message = response.message
        }
    }
}

struct MaintenanceError: AppErrorTypeProtocol {
    var errorCode: String = ""
    var title: String = ""
    var message: String = "ただいまメンテナンス中です。"
    var userResponses: [AppErrorUserOption] {
        return [.ok]
    }
    var cancelUserResponse: AppErrorUserOption?

    init(_ errorCode: String, _ response: APIErrorResponse?) {
        self.errorCode = errorCode
        if let response = response {
            self.message = response.message
        }
    }
}

struct SystemError: AppErrorTypeProtocol {
    var errorCode: String = ""
    var title: String = ""
    var message: String = ""
    var userResponses: [AppErrorUserOption] {
        return [ .ok]
    }
    var cancelUserResponse: AppErrorUserOption?

    init(_ errorCode: String) {
        self.errorCode = errorCode
        self.message = errorMessageWithErrorCode(message: "システムでエラーが発生しました。", errorCode: errorCode)
    }
}
