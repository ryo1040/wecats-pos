//
//  GetCareInfoTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

final class GetCareInfoTranslator {
    static func generate(getCareInfoEntity: GetCareInfoEntity) -> [CareInfoModel] {
        
        var careInfoModel: [CareInfoModel] = []
        for entity in getCareInfoEntity.careInfoEntity {
            let model: CareInfoModel = CareInfoModel(catId: entity.catId, catName: entity.catName, careType: entity.careType, branch: entity.branch, careDate: entity.careDate, memo: entity.memo ?? "")
            careInfoModel.append(model)
        }
        return careInfoModel
    }
}
