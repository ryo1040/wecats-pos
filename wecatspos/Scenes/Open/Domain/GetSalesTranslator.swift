//
//  SalesMasterTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2026/04/06.
//

final class GetSalesTranslator {
    static func generate(getSalesEntity: GetSalesEntity) -> GetSalesModel {
        // マスタ
        var salesMaster: [SalesMasterModel] = []
        for entity in getSalesEntity.salesMaster {
            salesMaster.append(SalesMasterTranslator.generate(salesMaster: entity))
        }
        
        // トランザクション
        var sales: [SalesModel] = []
        for entity in getSalesEntity.sales {
            sales.append(SalesTranslator.generate(sales: entity))
        }
        
        var model: GetSalesModel = GetSalesModel()
        model.status = getSalesEntity.status
        model.salesMasterModel = salesMaster
        model.salesModel = sales
        return model
    }
}

final class SalesMasterTranslator {
    static func generate(salesMaster: SalesMasterEntity) -> SalesMasterModel {
        var model: SalesMasterModel = SalesMasterModel()
        model.id = salesMaster.id
        model.name = salesMaster.name
        model.price = salesMaster.price
        model.order = salesMaster.order
        model.memo = salesMaster.memo
        return model
    }
}

final class SalesTranslator {
    static func generate(sales: SalesEntity) -> SalesModel {
        var model: SalesModel = SalesModel()
        model.date = sales.date
        model.salesMasterId = sales.salesMasterId
        model.branch = sales.branch
        model.count = sales.count
        return model
    }
}
