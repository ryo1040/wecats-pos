//
//  SalesMasterModel.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/09.
//

public struct GetSalesMasterModel {
    public var status: Int
    public var salesMasterModel:  [SalesMasterModel]
    
    public init(status: Int, salesMasterModel: [SalesMasterModel]) {
        self.status = status
        self.salesMasterModel = salesMasterModel
    }
    
    public init() {
        self.status = -1
        self.salesMasterModel = []
    }
}

public struct SalesMasterModel {
    public var id: Int
    public var branch: Int
    public var name: String
    public var price: Int
    public var order: Int
    public var memo: String

    public init(id: Int, branch: Int, name: String, price: Int, order: Int, memo: String) {
        self.id = id
        self.branch = branch
        self.name = name
        self.price = price
        self.order = order
        self.memo = memo
    }
    
    public init() {
        self.id = -1
        self.branch = -1
        self.name = ""
        self.price = -1
        self.order = -1
        self.memo = ""
    }
}
