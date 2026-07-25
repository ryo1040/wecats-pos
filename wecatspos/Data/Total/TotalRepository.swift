//
//  TotalRepository.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/09.
//

import Foundation
import RxSwift

protocol TotalRepositoryProtocol {
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func getTotalAmountList(param: GetTotalAmountListRequestParam) -> Single<GetTotalAmountListEntity>
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func getSales(param: GetSalesMasterRequestParam) -> Single<GetSalesEntity>
    func getReservationNightInfo(param: GetReservationNightRequestParam) -> Single<GetReservationNightEntity>
    func setReservationNightInfo(param: PostReservationNightRequestParam) -> Single<GetGuestInfoEntity>
    func deleteReservationNightInfo(param: PostDeleteReservationNightRequestParam) -> Single<GetGuestInfoEntity>
}

final class TotalRepository: TotalRepositoryProtocol {
    lazy var totalDataStore = TotalDataStoreFactory.createTotalDataStore()
    
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return totalDataStore.getGuestInfo(param: param)
    }
    
    func getTotalAmountList(param: GetTotalAmountListRequestParam) -> Single<GetTotalAmountListEntity> {
        return totalDataStore.getTotalAmountList(param: param)
    }
    
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return totalDataStore.updateGuestInfo(param: param)
    }
    
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return totalDataStore.deleteGuestInfo(param: param)
    }
    
    func getSales(param: GetSalesMasterRequestParam) -> Single<GetSalesEntity> {
        return totalDataStore.getSales(param: param)
    }
    
    func getReservationNightInfo(param: GetReservationNightRequestParam) -> Single<GetReservationNightEntity> {
        return totalDataStore.getReservationNightInfo(param: param)
    }
    
    func setReservationNightInfo(param: PostReservationNightRequestParam) -> Single<GetGuestInfoEntity> {
        return totalDataStore.setReservationNightInfo(param: param)
    }
    
    func deleteReservationNightInfo(param: PostDeleteReservationNightRequestParam) -> Single<GetGuestInfoEntity> {
        return totalDataStore.deleteReservationNightInfo(param: param)
    }
}
