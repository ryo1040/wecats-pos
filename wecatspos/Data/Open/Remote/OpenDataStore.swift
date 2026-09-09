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
    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Single<GetTotalAmountEntity>
//    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Single<GetTotalAmountEntity>
    func getSales(param: GetSalesMasterRequestParam) -> Single<GetSalesEntity>
    func setSales(param: PostSalesRequestParam) -> Single<GetSalesEntity>
    func getReservationNightInfo(param: GetReservationNightRequestParam) -> Single<GetReservationNightEntity>
    func setReservationNightInfo(param: PostReservationNightRequestParam) -> Single<GetGuestInfoEntity>
    func deleteReservationNightInfo(param: PostDeleteReservationNightRequestParam) -> Single<GetGuestInfoEntity>
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
    
    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Single<GetTotalAmountEntity> {
//    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Single<GetTotalAmountEntity> {
        return APIClient.shared.request(GetCalcTotalAmountTargetType(param))
    }
    
    func getSales(param: GetSalesMasterRequestParam) -> Single<GetSalesEntity> {
        return APIClient.shared.request(GetSalesTargetType(param))
    }
    
    func setSales(param: PostSalesRequestParam) -> Single<GetSalesEntity> {
        return APIClient.shared.request(SetSalesTargetType(param))
    }
    
    func getReservationNightInfo(param: GetReservationNightRequestParam) -> Single<GetReservationNightEntity> {
        return APIClient.shared.request(GetReservationNightTargetType(param))
    }
    
    func setReservationNightInfo(param: PostReservationNightRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(SetReservationNightTargetType(param))
    }
    
    func deleteReservationNightInfo(param: PostDeleteReservationNightRequestParam) -> Single<GetGuestInfoEntity> {
        return APIClient.shared.request(DeleteReservationNightTargetType(param))
    }
}

struct OpenDataStoreFactory {
    static func createOpenDataStore() -> OpenDataStoreProtocol {
        OpenDataStore()
    }
}

