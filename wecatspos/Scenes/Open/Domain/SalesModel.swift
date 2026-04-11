//
//  SalesModel.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/05.
//
 
public struct GetSalesModel {
    public var status: Int
    public var salesMasterModel:  [SalesMasterModel]
    public var salesModel: [SalesModel]
    
    public init(status: Int, salesMasterModel: [SalesMasterModel], salesModel: [SalesModel]) {
        self.status = status
        self.salesMasterModel = salesMasterModel
        self.salesModel = salesModel
    }
    
    public init() {
        self.status = -1
        self.salesMasterModel = []
        self.salesModel = []
    }
}

public struct SalesMasterModel {
    public var id: Int
    public var name: String
    public var price: Int
    public var order: Int
    public var memo: String

    public init(id: Int, name: String, price: Int, order: Int, memo: String) {
        self.id = id
        self.name = name
        self.price = price
        self.order = order
        self.memo = memo
    }
    
    public init() {
        self.id = -1
        self.name = ""
        self.price = -1
        self.order = -1
        self.memo = ""
    }
}

public struct SalesModel {
    public var date: String
    public var salesMasterId: Int
    public var branch: Int
    public var count: Int
    
    public init(date: String, salesMasterId: Int, branch: Int, count: Int) {
        self.date = date
        self.salesMasterId = salesMasterId
        self.branch = branch
        self.count = count
    }
    
    public init() {
        self.date = ""
        self.salesMasterId = -1
        self.branch = -1
        self.count = -1
    }
}
