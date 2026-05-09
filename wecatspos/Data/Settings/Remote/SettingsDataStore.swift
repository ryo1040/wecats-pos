//
//  SettingsDataStore.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import RxSwift

protocol SettingsDataStoreProtocol {
    func getSalesMaster() -> Single<GetSalesMasterEntity>
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesMasterEntity>
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesMasterEntity>
}

final class SettingsDataStore: SettingsDataStoreProtocol {
    func getSalesMaster() -> Single<GetSalesMasterEntity> {
        return APIClient.shared.request(GetSalesMasterTargetType())
    }
    
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesMasterEntity> {
        return APIClient.shared.request(SetSalesMasterTargetType(param))
    }
    
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesMasterEntity> {
        return APIClient.shared.request(DeleteSalesMasterTargetType(param))
    }
}

struct SettingsDataStoreFactory {
    static func createSettingsDataStore() -> SettingsDataStoreProtocol {
        SettingsDataStore()
    }
}
