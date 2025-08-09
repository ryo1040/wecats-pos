//
//  GetCatInfoEntity.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/02.
//

public struct GetCatInfoEntity: Codable {
    var status: Int
    var catInfo: [CatInfoEntity]
    
    enum CodingKeys: String, CodingKey {
        case status
        case catInfo
    }
}

public struct CatInfoEntity: Codable {
    var id: Int
    var name: String
    var sex: Int
    var pic: String?
    var breed: String
    var birthday: String
    var vaccine: Int
    var microchip: Bool
    var contraception: Bool
    var salePrice: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case sex = "sex"
        case pic = "pic"
        case breed = "breed"
        case birthday = "birthday"
        case vaccine = "vaccine"
        case microchip = "microchip"
        case contraception = "contraception"
        case salePrice = "sale_price"
    }
}
