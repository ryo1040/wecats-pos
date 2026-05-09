//
//  SettingsUseCase.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import RxSwift
import HolidayJp

protocol SettingsUseCaseProtocol: AnyObject {
    func getSalesMaster() -> Observable<GetSalesMasterModel>
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Observable<GetSalesMasterModel>
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Observable<GetSalesMasterModel>
}

final class SettingsUseCase: SettingsUseCaseProtocol {
    
    private var settingsRepository: SettingsRepositoryProtocol!
    
    init(settingsRepository: SettingsRepositoryProtocol) {
        self.settingsRepository = settingsRepository
    }
    
    func getSalesMaster() -> Observable<GetSalesMasterModel> {
        self.settingsRepository.getSalesMaster().asObservable().map { entity in
            GetSalesMasterTranslator.generate(getSalesMasterEntity: entity)
        }
    }
    
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Observable<GetSalesMasterModel> {
        self.settingsRepository.setSalesMaster(param: param).asObservable().map { entity in
            GetSalesMasterTranslator.generate(getSalesMasterEntity: entity)
        }
    }
    
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Observable<GetSalesMasterModel> {
        self.settingsRepository.deleteSalesMaster(param: param).asObservable().map { entity in
            GetSalesMasterTranslator.generate(getSalesMasterEntity: entity)
        }
    }

}
