//
//  SettingsRepository.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import RxSwift

protocol SettingsRepositoryProtocol {
    func getSalesMaster() -> Single<GetSalesMasterEntity>
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesMasterEntity>
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesMasterEntity>
}

final class SettingsRepository: SettingsRepositoryProtocol {
    lazy var settingsDataStore = SettingsDataStoreFactory.createSettingsDataStore()
    
    func getSalesMaster() -> Single<GetSalesMasterEntity> {
        return settingsDataStore.getSalesMaster()
    }
    
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesMasterEntity> {
        return settingsDataStore.setSalesMaster(param: param)
    }
    
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesMasterEntity> {
        return settingsDataStore.deleteSalesMaster(param: param)
    }
}
