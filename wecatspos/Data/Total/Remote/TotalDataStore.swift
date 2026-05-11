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
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func getSales(param: GetSalesMasterRequestParam) -> Single<GetSalesEntity>
}

final class TotalDataStore: TotalDataStoreProtocol {

    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(GetGuestInfoTargetType(param))
    }
    
    func getTotalAmountList(param: GetTotalAmountListRequestParam) -> Single<GetTotalAmountListEntity> {
        return APIClient.shared.request(GetTotalAmountListTargetType(param))
    }
    
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(SetGuestInfoTargetType(param))
    }
    
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(DeleteGuestInfoTargetType(param))
    }
    
    func getSales(param: GetSalesMasterRequestParam) -> Single<GetSalesEntity> {
        return APIClient.shared.request(GetSalesTargetType(param))
    }
}

struct TotalDataStoreFactory {
    static func createTotalDataStore() -> TotalDataStoreProtocol {
        TotalDataStore()
    }
}
