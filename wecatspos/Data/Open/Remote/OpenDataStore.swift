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
    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Single<CalcTotalAmountEntity>
    func getSales(param: GetSalesMasterRequestParam) -> Single<GetSalesEntity>
    func setSales(param: PostSalesRequestParam) -> Single<GetSalesEntity>
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
    
    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Single<CalcTotalAmountEntity> {
        return APIClient.shared.request(GetCalcTotalAmountTargetType(param))
    }
    
    func getSales(param: GetSalesMasterRequestParam) -> Single<GetSalesEntity> {
        return APIClient.shared.request(GetSalesTargetType(param))
    }
    
    func setSales(param: PostSalesRequestParam) -> Single<GetSalesEntity> {
        return APIClient.shared.request(SetSalesTargetType(param))
    }
}

struct OpenDataStoreFactory {
    static func createOpenDataStore() -> OpenDataStoreProtocol {
        OpenDataStore()
    }
}

