//
//  DenominationModel.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/19.
//

public struct DenominationModel {

    public var date: String
    public var branch: Int
    public var tenThousandYenCount: Int
    public var fiveThousandYenCount: Int
    public var twoThousandYenCount: Int
    public var oneThousandYenCount: Int
    public var fiveHundredYenCount: Int
    public var oneHundredYenCount: Int
    public var fiftyYenCount: Int
    public var tenYenCount: Int
    public var fiveYenCount: Int
    public var oneYenCount: Int
    public var ticketCount: Int
    public var exportAmount: Int
    public var totalAmount: Int
    public var memo: String?
    
    public init(date: String, branch: Int, tenThousandYenCount: Int, fiveThousandYenCount: Int, twoThousandYenCount: Int, oneThousandYenCount: Int, fiveHundredYenCount: Int, oneHundredYenCount: Int, fiftyYenCount: Int, tenYenCount: Int, fiveYenCount: Int, oneYenCount: Int, ticketCount: Int, exportAmount: Int, totalAmount: Int, memo: String?){
        self.date = date
        self.branch = branch
        self.tenThousandYenCount = tenThousandYenCount
        self.fiveThousandYenCount = fiveThousandYenCount
        self.twoThousandYenCount = twoThousandYenCount
        self.oneThousandYenCount = oneThousandYenCount
        self.fiveHundredYenCount = fiveHundredYenCount
        self.oneHundredYenCount = oneHundredYenCount
        self.fiftyYenCount = fiftyYenCount
        self.tenYenCount = tenYenCount
        self.fiveYenCount = fiveYenCount
        self.oneYenCount = oneYenCount
        self.ticketCount = ticketCount
        self.exportAmount = exportAmount
        self.totalAmount = totalAmount
        self.memo = memo
    }
    
    public init () {
        self.date = ""
        self.branch = 0
        self.tenThousandYenCount = 0
        self.fiveThousandYenCount = 0
        self.twoThousandYenCount = 0
        self.oneThousandYenCount = 0
        self.fiveHundredYenCount = 0
        self.oneHundredYenCount = 0
        self.fiftyYenCount = 0
        self.tenYenCount = 0
        self.fiveYenCount = 0
        self.oneYenCount = 0
        self.ticketCount = 0
        self.exportAmount = 0
        self.totalAmount = 0
        self.memo = ""
    }
}
