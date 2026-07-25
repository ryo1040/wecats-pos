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
    func getReservationNightInfo(param: GetReservationNightRequestParam) -> Single<GetReservationNightEntity>
    func setReservationNightInfo(param: PostReservationNightRequestParam) -> Single<GetGuestInfoEntity>
    func deleteReservationNightInfo(param: PostDeleteReservationNightRequestParam) -> Single<GetGuestInfoEntity>
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

struct TotalDataStoreFactory {
    static func createTotalDataStore() -> TotalDataStoreProtocol {
        TotalDataStore()
    }
}
