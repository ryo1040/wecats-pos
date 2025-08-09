//
//  APIClient.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/14.
//

import Alamofire
import Moya
import RxSwift

struct APIClient {
    static let shared = APIClient()

    // MARK: - Private

    private let provider = MoyaProvider<MultiTarget>(session: DefaultAlamofireSession.sharedSession)

    // MARK: - Public

    func request<G: ApiTargetType>(_ request: G) -> Single<G.Reponse> {

        Single<G.Reponse>.create { observer in
            self.makeRequest(request)
                .subscribe(onSuccess: { response in
                    observer(.success(response))
                }, onFailure: { error in
                    if let error = error as? MoyaError {
                        print(error)
                        observer(.failure(error.errorType))
                    } else {
                        observer(.failure(error))
                    }
                })
        }
    }

    func makeRequest<G: ApiTargetType>(_ request: G) -> Single<G.Reponse> {
        provider.rx
            .request(MultiTarget(request))
            .flatMap { response -> Single<Response> in
                // エラーコードのチェック
                return Single.just(try response.successfulStatusCodesPolicy())
            }
            .map(G.Reponse.self, failsOnEmptyData: false)
    }
}

