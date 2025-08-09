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
}

final class TotalRepository: TotalRepositoryProtocol {
    lazy var totalDataStore = TotalDataStoreFactory.createTotalDataStore()
    
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return totalDataStore.getGuestInfo(param: param)
    }
    
    func getTotalAmountList(param: GetTotalAmountListRequestParam) -> Single<GetTotalAmountListEntity> {
        return totalDataStore.getTotalAmountList(param: param)
    }
}
