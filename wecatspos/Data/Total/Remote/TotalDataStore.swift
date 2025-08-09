//
//  TotalDataStore.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/09.
//

import Foundation
import RxSwift

protocol TotalDataStoreProtocol {
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func getTotalAmountList(param: GetTotalAmountListRequestParam) -> Single<GetTotalAmountListEntity>
}

final class TotalDataStore: TotalDataStoreProtocol {

    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(GetGuestInfoTargetType(param))
    }
    
    func getTotalAmountList(param: GetTotalAmountListRequestParam) -> Single<GetTotalAmountListEntity> {
        return APIClient.shared.request(GetTotalAmountListTargetType(param))
    }
}

struct TotalDataStoreFactory {
    static func createTotalDataStore() -> TotalDataStoreProtocol {
        TotalDataStore()
    }
}
