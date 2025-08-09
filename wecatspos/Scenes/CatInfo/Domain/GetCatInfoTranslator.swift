//
//  GetCatInfoTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/02.
//

final class GetCatInfoTranslator {
    static func generate(getCatInfoEntity: GetCatInfoEntity) -> [CatInfoModel] {
        
        var catInfoModel: [CatInfoModel] = []
        for entity in getCatInfoEntity.catInfo {
            let model: CatInfoModel = CatInfoModel(id: entity.id, name: entity.name, sex: entity.sex, pic: entity.pic ?? "", breed: entity.breed, birthday: entity.birthday, vaccine: entity.vaccine, microchip: entity.microchip, contraception: entity.contraception, salePrice: entity.salePrice)
            catInfoModel.append(model)
        }
        return catInfoModel
    }
}
