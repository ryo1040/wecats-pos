//
//  CatInfoDataStore.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/02.
//

import Foundation
import RxSwift

protocol CatInfoDataStoreProtocol {
    func getCatInfo() -> Single<GetCatInfoEntity>
    func getMedicalHistory(param: GetMedicalHistoryRequestParam) -> Single<GetMedicalHistoryEntity>
    func setMedicalHistory(param: PostMedicalHistoryRequestParam) -> Single<GetMedicalHistoryEntity>
}

final class CatInfoDataStore: CatInfoDataStoreProtocol {

    func getCatInfo() -> Single<GetCatInfoEntity> {
        return APIClient.shared.request(GetCatInfoTargetType())
    }
    
    func getMedicalHistory(param: GetMedicalHistoryRequestParam) -> Single<GetMedicalHistoryEntity> {
        return APIClient.shared.request(GetMedicalHistoryTargetType(param))
    }
    
    func setMedicalHistory(param: PostMedicalHistoryRequestParam) -> Single<GetMedicalHistoryEntity> {
        return APIClient.shared.request(SetMedicalHistoryTargetType(param))
    }
}

struct CatInfoDataStoreFactory {
    static func createCatInfoDataStore() -> CatInfoDataStoreProtocol {
        CatInfoDataStore()
    }
}
