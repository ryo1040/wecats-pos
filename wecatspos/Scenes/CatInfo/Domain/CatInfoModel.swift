//
//  CatInfoModel.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/02.
//

public struct CatInfoModel {
    public var id: Int
    public var name: String
    public var sex: Int
    public var pic: String?
    public var breed: String
    public var birthday: String
    public var vaccine: Int
    public var microchip: Bool
    public var contraception: Bool
    public var salePrice: Int
    
    public init(id: Int, name: String, sex: Int, pic: String, breed: String, birthday: String, vaccine: Int, microchip: Bool, contraception: Bool, salePrice: Int){
        self.id = id
        self.name = name
        self.sex = sex
        self.pic = pic
        self.breed = breed
        self.birthday = birthday
        self.vaccine = vaccine
        self.microchip = microchip
        self.contraception = contraception
        self.salePrice = salePrice
    }
}
