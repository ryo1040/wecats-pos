//
//  ReservationNightViewModel.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/22.
//

public struct GetReservationNightViewModel {
    public var status: Int
    public var reservationNightViewModel: [ReservationNightViewModel]
    
    public init(status: Int, reservationNightViewModel: [ReservationNightViewModel]) {
        self.status = status
        self.reservationNightViewModel = reservationNightViewModel
    }
    
    public init() {
        self.status = -1
        self.reservationNightViewModel = []
    }
}

public struct ReservationNightViewModel {
    public var id: Int
    public var branch: Int
    public var date: String
    public var name: String
    public var count: Int
    public var tel: String
    public var price: Int
    public var memo: String

    public init(id: Int, branch: Int, date: String, name: String, count: Int, tel: String, price: Int, memo: String) {
        self.id = id
        self.branch = branch
        self.date = date
        self.name = name
        self.count = count
        self.tel = tel
        self.price = price
        self.memo = memo
    }
    
    public init() {
        self.id = -1
        self.branch = -1
        self.date = ""
        self.name = ""
        self.count = -1
        self.tel = ""
        self.price = -1
        self.memo = ""
    }
}
