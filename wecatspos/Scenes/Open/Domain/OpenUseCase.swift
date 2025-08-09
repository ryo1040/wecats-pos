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

}
