//
//  AppErrorTypeProtocol.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/14.
//

protocol AppErrorTypeProtocol {
    var errorCode: String { get }
    var title: String { get }
    var message: String { get }
    var userResponses: [AppErrorUserOption] { get }
    var cancelUserResponse: AppErrorUserOption? { get }
}

extension AppErrorTypeProtocol {
    func errorMessageWithErrorCode(message: String, errorCode: String) -> String {
        return message
            + "\n"
            + "[エラーコード : \(errorCode)]"

    }
}
