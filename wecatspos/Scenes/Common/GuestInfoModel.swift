//
//  GuestInfoModel.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/07.
//

public struct GuestInfoModel {
    public var id: Int
    public var repeatFlag: Bool
    public var patternId: Int
    public var name: String?
    public var adultCount: Int
    public var childCount: Int
    public var date: String
    public var holidayFlag: Bool
    public var kidsdayFlag: Bool
    public var enterTime: String
    public var leftTime: String
    public var stayTime: Int
    public var calcAmount: Int
    public var discountAmount: Int
    public var salesAmount: Int
    public var gachaAmount: Int
    public var totalAmount: Int
    public var stayingFlag: Bool
    public var memo: String?
    
    public init(id: Int, repeatFlag: Bool, patternId: Int, name: String?, adultCount: Int, childCount: Int, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, stayingFlag: Bool, memo: String?){
        self.id = id
        self.repeatFlag = repeatFlag
        self.patternId = patternId
        self.name = name
        self.adultCount = adultCount
        self.childCount = childCount
        self.date = date
        self.holidayFlag = holidayFlag
        self.kidsdayFlag = kidsdayFlag
        self.enterTime = enterTime
        self.leftTime = leftTime
        self.stayTime = stayTime
        self.calcAmount = calcAmount
        self.discountAmount = discountAmount
        self.salesAmount = salesAmount
        self.gachaAmount = gachaAmount
        self.totalAmount = totalAmount
        self.stayingFlag = stayingFlag
        self.memo = memo
    }
}
