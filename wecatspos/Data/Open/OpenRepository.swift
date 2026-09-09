//
//  OpenRepository.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/05.
//

import Foundation
import RxSwift

protocol OpenRepositoryProtocol {
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

final class OpenRepository: OpenRepositoryProtocol {
    lazy var openDataStore = OpenDataStoreFactory.createOpenDataStore()
    
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.getGuestInfo(param: param)
    }
    
    func setGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.setGuestInfo(param: param)
    }
    
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.updateGuestInfo(param: param)
    }
    
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.deleteGuestInfo(param: param)
    }
    
    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Single<GetTotalAmountEntity> {
//    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Single<GetTotalAmountEntity> {
        return openDataStore.calcTotalAmount(param: param)
    }
    
    func getSales(param: GetSalesMasterRequestParam) -> Single<GetSalesEntity> {
        return openDataStore.getSales(param: param)
    }
    
    func setSales(param: PostSalesRequestParam) -> Single<GetSalesEntity> {
        return openDataStore.setSales(param: param)
    }
    
    func getReservationNightInfo(param: GetReservationNightRequestParam) -> Single<GetReservationNightEntity> {
        return openDataStore.getReservationNightInfo(param: param)
    }
    
    func setReservationNightInfo(param: PostReservationNightRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.setReservationNightInfo(param: param)
    }
    
    func deleteReservationNightInfo(param: PostDeleteReservationNightRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.deleteReservationNightInfo(param: param)
    }
}
