//
//  MedicalHistoryModel.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/02.
//

public struct MedicalHistoryModel {
    public var id: Int
    public var catId: Int
    public var date: String
    public var reason: String
    public var treatment: String
    
    public init() {
        self.id = -1
        self.catId = -1
        self.date = ""
        self.reason = ""
        self.treatment = ""
    }
    
    public init(id: Int, catId: Int, date: String, reason: String, treatment: String){
        self.id = id
        self.catId = catId
        self.date = date
        self.reason = reason
        self.treatment = treatment
    }
}
