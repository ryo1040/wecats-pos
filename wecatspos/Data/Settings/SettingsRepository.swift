//
//  SettingsRepository.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import RxSwift

protocol SettingsRepositoryProtocol {
    func getSalesMaster() -> Single<GetSalesEntity>
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesEntity>
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesEntity>
}

final class SettingsRepository: SettingsRepositoryProtocol {
    lazy var settingsDataStore = SettingsDataStoreFactory.createSettingsDataStore()
    
    func getSalesMaster() -> Single<GetSalesEntity> {
        return settingsDataStore.getSalesMaster()
    }
    
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesEntity> {
        return settingsDataStore.setSalesMaster(param: param)
    }
    
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Single<GetSalesEntity> {
        return settingsDataStore.deleteSalesMaster(param: param)
    }
}
