//
//  OpenUseCase.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/05.
//

import Foundation
import RxSwift
import HolidayJp

protocol OpenUseCaseProtocol: AnyObject {
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Observable<[GuestInfoModel]>
    func checkDay(date: Date) -> Int
    func setGuestInfo(param: PostGuestInfoRequestParam) -> Observable<[GuestInfoModel]>
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Observable<[GuestInfoModel]>
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Observable<[GuestInfoModel]>
    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Observable<GetTotalAmountModel>
    func getSales(param: GetSalesMasterRequestParam) -> Observable<GetSalesModel>
    func setSales(param: PostSalesRequestParam) -> Observable<GetSalesModel>
    func getReservationNightInfo(param: GetReservationNightRequestParam) -> Observable<GetReservationNightViewModel>
    func setReservationNightInfo(param: PostReservationNightRequestParam) -> Observable<[GuestInfoModel]>
    func deleteReservationNightInfo(param: PostDeleteReservationNightRequestParam) -> Observable<[GuestInfoModel]>
}

final class OpenUseCase: OpenUseCaseProtocol {
    
    private var openRepository: OpenRepositoryProtocol!
    
    init(openRepository: OpenRepositoryProtocol) {
        self.openRepository = openRepository
    }
    
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Observable<[GuestInfoModel]> {
        openRepository.getGuestInfo(param: param).asObservable().map { entity in
            GetGuestInfoTranslator.generate(getGuestInfo: entity)
        }
    }
    
    func checkDay(date: Date) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        let day = calendar.component(.weekday, from: date)
        if day == 1 {
            return 1
        } else if day == 7 {
            return 3
        } else if HolidayJp.isHoliday(date) {
            return 1
        } else {
            return 0
        }
    }
    
    func setGuestInfo(param: PostGuestInfoRequestParam) -> Observable<[GuestInfoModel]> {
        self.openRepository.setGuestInfo(param: param).asObservable().map { entity in
            GetGuestInfoTranslator.generate(getGuestInfo: entity)
        }
    }
    
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Observable<[GuestInfoModel]> {
        self.openRepository.updateGuestInfo(param: param).asObservable().map { entity in
            GetGuestInfoTranslator.generate(getGuestInfo: entity)
        }
    }
    
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Observable<[GuestInfoModel]> {
        self.openRepository.deleteGuestInfo(param: param).asObservable().map { entity in
            GetGuestInfoTranslator.generate(getGuestInfo: entity)
        }
    }

    func calcTotalAmount(param: GetCalcTotalAmountRequestParam) -> Observable<GetTotalAmountModel> {
        self.openRepository.calcTotalAmount(param: param).asObservable().map { entity in
            GetTotalAmountTranslator.generate(calcTotalAmount: entity)
            
        }
    }
    
    func getSales(param: GetSalesMasterRequestParam) -> Observable<GetSalesModel> {
        self.openRepository.getSales(param: param).asObservable().map { entity in
            GetSalesTranslator.generate(getSalesEntity: entity)
        }
    }
    
    func setSales(param: PostSalesRequestParam) -> Observable<GetSalesModel> {
        self.openRepository.setSales(param: param).asObservable().map { entity in
            GetSalesTranslator.generate(getSalesEntity: entity)
        }
    }
    
    func getReservationNightInfo(param: GetReservationNightRequestParam) -> Observable<GetReservationNightViewModel> {
        self.openRepository.getReservationNightInfo(param: param).asObservable().map { entity in
            GetReservationNightInfoTranslator.generate(getReservationNightInfo: entity)
        }
    }
    
    func setReservationNightInfo(param: PostReservationNightRequestParam) -> Observable<[GuestInfoModel]> {
        self.openRepository.setReservationNightInfo(param: param).asObservable().map { entity in
            GetGuestInfoTranslator.generate(getGuestInfo: entity)
        }
    }
    
    func deleteReservationNightInfo(param: PostDeleteReservationNightRequestParam) -> Observable<[GuestInfoModel]> {
        self.openRepository.deleteReservationNightInfo(param: param).asObservable().map { entity in
            GetGuestInfoTranslator.generate(getGuestInfo: entity)
        }
    }
}
