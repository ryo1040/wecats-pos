//
//  OpenDataStore.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/05.
//

import Foundation
import RxSwift

protocol OpenDataStoreProtocol {
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func setGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func calcTotalAmount(param: PostCalcTotalAmountRequestParam) -> Single<CalcTotalAmountEntity>
}

final class OpenDataStore: OpenDataStoreProtocol {
    
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(GetGuestInfoTargetType(param))
    }

    func setGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(SetGuestInfoTargetType(param))
    }
    
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(SetGuestInfoTargetType(param))
    }
    
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(DeleteGuestInfoTargetType(param))
    }
    
    func calcTotalAmount(param: PostCalcTotalAmountRequestParam) -> Single<CalcTotalAmountEntity> {
        return APIClient.shared.request(PostCalcTotalAmountTargetType(param))
    }
}

struct OpenDataStoreFactory {
    static func createOpenDataStore() -> OpenDataStoreProtocol {
        OpenDataStore()
    }
}

