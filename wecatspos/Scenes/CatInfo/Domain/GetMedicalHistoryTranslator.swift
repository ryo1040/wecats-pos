//
//  GetMedicalHistoryTranslator.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/02.
//

final class GetMedicalHistoryTranslator {
    static func generate(getMedicalHistory: GetMedicalHistoryEntity) -> [MedicalHistoryModel] {
        
        var medicalHistoryModel: [MedicalHistoryModel] = []
        for entity in getMedicalHistory.medicalHistory {
            let model: MedicalHistoryModel = MedicalHistoryModel(id: entity.id, catId: entity.catId, date: entity.date, reason: entity.reason, treatment: entity.treatment)
            medicalHistoryModel.append(model)
        }
        return medicalHistoryModel
    }
}
