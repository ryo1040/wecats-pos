//
//  CalcTotalAmountModel.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/23.
//

public struct CheckTotalAmountModel {
    public var status: Int
    public var totalAmount: Int
    public var ticketAmount: Int
    public var exportAmpunt: Int
    public var lastDayTotalAmount: Int
    public var todaySales: Int
    public var checkResult: String
    
    public init(status: Int, totalAmount: Int, ticketAmount: Int, exportAmount: Int, lastDayTotalAmount: Int, todaySales: Int, checkResult: String){
        self.status = status
        self.totalAmount = totalAmount
        self.ticketAmount = ticketAmount
        self.exportAmpunt = exportAmount
        self.lastDayTotalAmount = lastDayTotalAmount
        self.todaySales = todaySales
        self.checkResult = checkResult
    }
    
    public init () {
        self.status = 0
        self.totalAmount = 0
        self.ticketAmount = 0
        self.exportAmpunt = 0
        self.lastDayTotalAmount = 0
        self.todaySales = 0
        self.checkResult = ""
    }
}
