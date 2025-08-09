//
//  CatInfoRepository.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/02.
//

import Foundation
import RxSwift

protocol CatInfoRepositoryProtocol {
    func getCatInfo() -> Single<GetCatInfoEntity>
    func getMedicalHistory(param: GetMedicalHistoryRequestParam) -> Single<GetMedicalHistoryEntity>
    func setMedicalHistory(param: PostMedicalHistoryRequestParam) -> Single<GetMedicalHistoryEntity>
}

final class CatInfoRepository: CatInfoRepositoryProtocol {
    lazy var catInfoDataStore = CatInfoDataStoreFactory.createCatInfoDataStore()
    
    func getCatInfo() -> Single<GetCatInfoEntity> {
        return catInfoDataStore.getCatInfo()
    }
    
    func getMedicalHistory(param: GetMedicalHistoryRequestParam) -> Single<GetMedicalHistoryEntity> {
        return catInfoDataStore.getMedicalHistory(param: param)
    }
    
    func setMedicalHistory(param: PostMedicalHistoryRequestParam) -> Single<GetMedicalHistoryEntity> {
        return catInfoDataStore.setMedicalHistory(param: param)
    }
}
