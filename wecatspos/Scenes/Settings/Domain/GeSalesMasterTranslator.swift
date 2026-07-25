//
//  GeSalesMasterTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/09.
//


final class GetSalesMasterTranslator {
    static func generate(getSalesMasterEntity: GetSalesMasterEntity) -> GetSalesMasterModel {
        var salesMaster: [SalesMasterModel] = []
        for entity in getSalesMasterEntity.salesMaster {
            salesMaster.append(SalesMasterTranslator.generate(salesMaster: entity))
        }
        
        var model: GetSalesMasterModel = GetSalesMasterModel()
        model.status = getSalesMasterEntity.status
        model.salesMasterModel = salesMaster
        return model
    }
}

final class SalesMasterTranslator {
    static func generate(salesMaster: SalesMasterEntity) -> SalesMasterModel {
        var model: SalesMasterModel = SalesMasterModel()
        model.id = salesMaster.id
        model.branch = salesMaster.branch
        model.name = salesMaster.name
        model.price = salesMaster.price
        model.order = salesMaster.order
        model.memo = salesMaster.memo
        return model
    }
}
