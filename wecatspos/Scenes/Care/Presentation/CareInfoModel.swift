//
//  CareModel.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

public struct CareInfoModel {
    public var catId: Int
    public var catName: String
    public var careType: Int
    public var branch: Int
    public var careDate: String
    public var memo: String
    
    public init(catId: Int, catName: String, careType: Int, branch: Int, careDate: String, memo: String){
        self.catId = catId
        self.catName = catName
        self.careType = careType
        self.branch = branch
        self.careDate = careDate
        self.memo = memo
    }
    
    public init () {
        self.catId = 0
        self.catName = ""
        self.careType = 0
        self.branch = 0
        self.careDate = ""
        self.memo = ""
    }
}

