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
    func getSalesMaster() -> Observable<GetSalesModel>
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Observable<GetSalesModel>
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Observable<GetSalesModel>
}

final class SettingsUseCase: SettingsUseCaseProtocol {
    
    private var settingsRepository: SettingsRepositoryProtocol!
    
    init(settingsRepository: SettingsRepositoryProtocol) {
        self.settingsRepository = settingsRepository
    }
    
    func getSalesMaster() -> Observable<GetSalesModel> {
        self.settingsRepository.getSalesMaster().asObservable().map { entity in
            GetSalesTranslator.generate(getSalesEntity: entity)
        }
    }
    
    func setSalesMaster(param: PostSalesMasterRequestParam) -> Observable<GetSalesModel> {
        self.settingsRepository.setSalesMaster(param: param).asObservable().map { entity in
            GetSalesTranslator.generate(getSalesEntity: entity)
        }
    }
    
    func deleteSalesMaster(param: PostSalesMasterRequestParam) -> Observable<GetSalesModel> {
        self.settingsRepository.deleteSalesMaster(param: param).asObservable().map { entity in
            GetSalesTranslator.generate(getSalesEntity: entity)
        }
    }

}
