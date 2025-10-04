//
//  CloseDataStore.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/19.
//

import Foundation
import RxSwift

protocol CloseDataStoreProtocol {
    func checkTotalAmount(param: PostCheckTotalAmountRequestParam) -> Single<PostCheckTotalAmountEntity>
    func getDenominationList(param: GetDenominationRequestParam) -> Single<GetDenominationEntity>
    func setDenominaiton(param: PostDenominationRequestParam) -> Single<GetDenominationEntity>
    func deleteDenominaiton(param: PostDenominationDeleteRequestParam) -> Single<GetDenominationEntity>
}

final class CloseDataStore: CloseDataStoreProtocol {
    func checkTotalAmount(param: PostCheckTotalAmountRequestParam) -> Single<PostCheckTotalAmountEntity> {
        return APIClient.shared.request(CheckTotalAmountTargetType(param))
    }
    
    func getDenominationList(param: GetDenominationRequestParam) -> Single<GetDenominationEntity> {
        return APIClient.shared.request(GetDenominationTargetType(param))
    }
    
    func setDenominaiton(param: PostDenominationRequestParam) -> Single<GetDenominationEntity> {
        return APIClient.shared.request(SetDenominationTargetType(param))
    }
    
    func deleteDenominaiton(param: PostDenominationDeleteRequestParam) -> Single<GetDenominationEntity> {
        return APIClient.shared.request(DeleteDenominationTargetType(param))
    }
}

struct CloseDataStoreFactory {
    static func createCloseDataStore() -> CloseDataStoreProtocol {
        CloseDataStore()
    }
}
