//
//  CloseUseCase.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/19.
//

import Foundation
import RxSwift
import HolidayJp

protocol CloseUseCaseProtocol: AnyObject {
    func getDenominationList(param: GetDenominationRequestParam) -> Observable<[DenominationModel]>
    func checkTotalAmount(param: PostCheckTotalAmountRequestParam) -> Observable<CheckTotalAmountModel>
    func setDenominaiton(param: PostDenominationRequestParam) -> Observable<[DenominationModel]>
    func deleteDenominaiton(param: PostDenominationDeleteRequestParam) -> Observable<[DenominationModel]>
}

final class CloseUseCase: CloseUseCaseProtocol {
    
    private var closeRepository: CloseRepositoryProtocol!
    
    init(closeRepository: CloseRepositoryProtocol) {
        self.closeRepository = closeRepository
    }
    
    func getDenominationList(param: GetDenominationRequestParam) -> Observable<[DenominationModel]> {
        return closeRepository.getDenominationList(param: param).asObservable().map { entity in
            GetDenominationTranslator.generate(denominationEntity: entity)
        }
    }
    
    func checkTotalAmount(param: PostCheckTotalAmountRequestParam) -> Observable<CheckTotalAmountModel> {
        self.closeRepository.checkTotalAmount(param: param).asObservable().map { entity in
            CheckTotalAmountTranslator.generate(checkTotalAmountEntity: entity)
        }
    }
    
    func setDenominaiton(param: PostDenominationRequestParam) -> Observable<[DenominationModel]> {
        return closeRepository.setDenomination(param: param).asObservable().map { entity in
            GetDenominationTranslator.generate(denominationEntity: entity)
        }
    }
    
    func deleteDenominaiton(param: PostDenominationDeleteRequestParam) -> Observable<[DenominationModel]> {
        return closeRepository.deleteDenomination(param: param).asObservable().map { entity in
            GetDenominationTranslator.generate(denominationEntity: entity)
        }
    }
}
