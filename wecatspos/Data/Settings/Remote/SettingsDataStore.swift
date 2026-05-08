//
//  SettingsDataStore.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import RxSwift

protocol SettingsDataStoreProtocol {
    func getSalesMaster() -> Single<GetSalesEntity>
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesEntity>
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesEntity>
}

final class SettingsDataStore: SettingsDataStoreProtocol {
    func getSalesMaster() -> Single<GetSalesEntity> {
        return APIClient.shared.request(GetSalesMasterTargetType())
    }
    
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesEntity> {
        return APIClient.shared.request(SetSalesMasterTargetType(param))
    }
    
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesEntity> {
        return APIClient.shared.request(DeleteSalesMasterTargetType(param))
    }
}

struct SettingsDataStoreFactory {
    static func createSettingsDataStore() -> SettingsDataStoreProtocol {
        SettingsDataStore()
    }
}
