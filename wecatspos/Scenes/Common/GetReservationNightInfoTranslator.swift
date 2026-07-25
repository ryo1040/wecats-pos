//
//  GetReservationNightInfoTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/22.
//

final class GetReservationNightInfoTranslator {
    static func generate(getReservationNightInfo: GetReservationNightEntity) -> GetReservationNightViewModel {
        // マスタ
        var reservationNightViewModel: [ReservationNightViewModel] = []
        for entity in getReservationNightInfo.reservationNight {
            reservationNightViewModel.append(ReservationNightInfoTranslator.generate(reservationNightinfo: entity))
        }
        
        var model: GetReservationNightViewModel = GetReservationNightViewModel()
        model.status = getReservationNightInfo.status
        model.reservationNightViewModel = reservationNightViewModel
        return model
    }
}

final class ReservationNightInfoTranslator {
    static func generate(reservationNightinfo: ReservationNightEntity) -> ReservationNightViewModel {
        var model: ReservationNightViewModel = ReservationNightViewModel()
        model.id = reservationNightinfo.id
        model.branch = reservationNightinfo.branch
        model.date = reservationNightinfo.date
        model.name = reservationNightinfo.name
        model.count = reservationNightinfo.count
        model.tel = reservationNightinfo.tel
        model.price = reservationNightinfo.price
        model.memo = reservationNightinfo.memo
        return model
    }
}
