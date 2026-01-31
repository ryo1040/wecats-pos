//
//  CareDataStore.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import Foundation
import RxSwift

protocol CareDataStoreProtocol {
    func getCareInfoList(param: GetCareInfoRequestParam) -> Single<GetCareInfoEntity>
    func setCareInfoList(param: SetCareInfoRequestParam) -> Single<GetCareInfoEntity>
    func deleteCareInfoList(param: DeleteCareInfoRequestParam) -> Single<GetCareInfoEntity>
}

final class CareDataStore: CareDataStoreProtocol {
    
    func getCareInfoList(param: GetCareInfoRequestParam) -> Single<GetCareInfoEntity> {
        return APIClient.shared.request(GetCareInfoTargetType(param))
    }
    
    func setCareInfoList(param: SetCareInfoRequestParam) -> Single<GetCareInfoEntity> {
        return APIClient.shared.request(SetCareInfoTargetType(param))
    }
    
    func deleteCareInfoList(param: DeleteCareInfoRequestParam) -> Single<GetCareInfoEntity> {
        return APIClient.shared.request(DeleteCareInfoTargetType(param))
    }
}

struct CareDataStoreFactory {
    static func createCareDataStore() -> CareDataStoreProtocol {
        CareDataStore()
    }
}
