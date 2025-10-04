//
//  CloseRepository.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/19.
//

import Foundation
import RxSwift

protocol CloseRepositoryProtocol {
    func checkTotalAmount(param: PostCheckTotalAmountRequestParam) -> Single<PostCheckTotalAmountEntity>
    func getDenominationList(param: GetDenominationRequestParam) -> Single<GetDenominationEntity>
    func setDenomination(param: PostDenominationRequestParam) -> Single<GetDenominationEntity>
    func deleteDenomination(param: PostDenominationDeleteRequestParam) -> Single<GetDenominationEntity>
}

final class CloseRepository: CloseRepositoryProtocol {
    lazy var closeDataStore = CloseDataStoreFactory.createCloseDataStore()
    
    func checkTotalAmount(param: PostCheckTotalAmountRequestParam) -> Single<PostCheckTotalAmountEntity> {
        return closeDataStore.checkTotalAmount(param: param)
    }
    
    func getDenominationList(param: GetDenominationRequestParam) -> Single<GetDenominationEntity> {
        return closeDataStore.getDenominationList(param: param)
    }
    
    func setDenomination(param: PostDenominationRequestParam) -> Single<GetDenominationEntity> {
        return closeDataStore.setDenominaiton(param: param)
    }
    
    func deleteDenomination(param: PostDenominationDeleteRequestParam) -> Single<GetDenominationEntity> {
        return closeDataStore.deleteDenominaiton(param: param)
    }
}
