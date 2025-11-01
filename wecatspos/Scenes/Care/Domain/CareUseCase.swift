//
//  CareUseCase.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import Foundation
import RxSwift
import HolidayJp

protocol CareUseCaseProtocol: AnyObject {
    func getCareInfoList(param: GetCareInfoRequestParam) -> Observable<[CareInfoModel]>
    func setCareInfoList(param: SetCareInfoRequestParam) -> Observable<[CareInfoModel]>
    func deleteCareInfoList(param: DeleteCareInfoRequestParam) -> Observable<[CareInfoModel]>
}

final class CareUseCase: CareUseCaseProtocol {
    
    private var careRepository: CareRepositoryProtocol!
    
    init(careRepository: CareRepositoryProtocol) {
        self.careRepository = careRepository
    }
    
    func getCareInfoList(param: GetCareInfoRequestParam) -> Observable<[CareInfoModel]> {
        return careRepository.getCareInfoList(param: param).asObservable().map { entity in
            GetCareInfoTranslator.generate(getCareInfoEntity: entity)
        }
    }
    
    func setCareInfoList(param: SetCareInfoRequestParam) -> Observable<[CareInfoModel]> {
        return careRepository.setCareInfoList(param: param).asObservable().map { entity in
            GetCareInfoTranslator.generate(getCareInfoEntity: entity)
        }
    }
    
    func deleteCareInfoList(param: DeleteCareInfoRequestParam) -> Observable<[CareInfoModel]> {
        return careRepository.deleteCareInfoList(param: param).asObservable().map { entity in
            GetCareInfoTranslator.generate(getCareInfoEntity: entity)
        }
    }
}
