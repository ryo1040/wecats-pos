//
//  TotalUseCase.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/09.
//

import Foundation
import RxSwift

protocol TotalUseCaseProtocol: AnyObject {
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Observable<[GuestInfoModel]>
    func getTotalAmountList(param: GetTotalAmountListRequestParam) -> Observable<[TotalAmountListModel]>
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Observable<[GuestInfoModel]>
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Observable<[GuestInfoModel]>
}

final class TotalUseCase: TotalUseCaseProtocol {
    
    private var totalRepository: TotalRepositoryProtocol!
    
    init(totalRepository: TotalRepositoryProtocol) {
        self.totalRepository = totalRepository
    }
    
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Observable<[GuestInfoModel]> {
        totalRepository.getGuestInfo(param: param).asObservable().map { entity in
            GetGuestInfoTranslator.generate(getGuestInfo: entity)
        }
    }
    
    func getTotalAmountList(param: GetTotalAmountListRequestParam) -> Observable<[TotalAmountListModel]> {
        totalRepository.getTotalAmountList(param: param).asObservable().map { entity in
            GetTotalAmountListTranslator.generate(getTotalAmountList: entity)
        }
    }
    
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Observable<[GuestInfoModel]> {
        totalRepository.updateGuestInfo(param: param).asObservable().map { entity in
            GetGuestInfoTranslator.generate(getGuestInfo: entity)
        }
    }
    
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Observable<[GuestInfoModel]> {
        totalRepository.deleteGuestInfo(param: param).asObservable().map { entity in
            GetGuestInfoTranslator.generate(getGuestInfo: entity)
        }
    }
}
