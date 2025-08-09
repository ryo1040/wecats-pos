//
//  CatInfoUseCase.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/02.
//

import Foundation
import RxSwift

protocol CatInfoUseCaseProtocol: AnyObject {
    func getCatInfo() -> Observable<[CatInfoModel]>
    func getMedicalHistory(param: GetMedicalHistoryRequestParam) -> Observable<[MedicalHistoryModel]>
    func setMedicalHistory(param: PostMedicalHistoryRequestParam) -> Observable<[MedicalHistoryModel]>
}

final class CatInfoUseCase: CatInfoUseCaseProtocol {
    
    private var catInfoRepository: CatInfoRepositoryProtocol!
    
    init(catInfoRepository: CatInfoRepositoryProtocol) {
        self.catInfoRepository = catInfoRepository
    }
    
    func getCatInfo() -> Observable<[CatInfoModel]> {
        self.catInfoRepository.getCatInfo().asObservable().map{ entity in
            GetCatInfoTranslator.generate(getCatInfoEntity: entity)
        }
    }
    
    func getMedicalHistory(param: GetMedicalHistoryRequestParam) -> Observable<[MedicalHistoryModel]> {
        self.catInfoRepository.getMedicalHistory(param: param).asObservable().map{ entity in
            GetMedicalHistoryTranslator.generate(getMedicalHistory: entity)
        }
    }
    
    func setMedicalHistory(param: PostMedicalHistoryRequestParam) -> Observable<[MedicalHistoryModel]> {
        self.catInfoRepository.setMedicalHistory(param: param).asObservable().map { entity in
            GetMedicalHistoryTranslator.generate(getMedicalHistory: entity)
        }
    }
}
