//
//  DefaultAlamofireSession.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/14.
//

import Alamofire
import Moya

final class DefaultAlamofireSession: Alamofire.Session {

    static let sharedSession: DefaultAlamofireSession = {

        let configuration = URLSessionConfiguration.default
        configuration.headers = .default

        // データの転送が始まるまで待機時間 (default: 60sconds)
        configuration.timeoutIntervalForRequest = 60

        // 全てのデータを転送するまでの待機時間 (default: 7days)
        configuration.timeoutIntervalForResource = 60

        // キャッシュポリシー
        configuration.requestCachePolicy = .useProtocolCachePolicy

        return DefaultAlamofireSession(configuration: configuration)
    }()

}
