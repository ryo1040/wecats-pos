//
//  CareRepository.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import Foundation
import RxSwift

protocol CareRepositoryProtocol {
    func getCareInfoList(param: GetCareInfoRequestParam) -> Single<GetCareInfoEntity>
    func setCareInfoList(param: SetCareInfoRequestParam) -> Single<GetCareInfoEntity>
    func deleteCareInfoList(param: DeleteCareInfoRequestParam) -> Single<GetCareInfoEntity>
}

final class CareRepository: CareRepositoryProtocol {
    lazy var careDataStore = CareDataStoreFactory.createCareDataStore()
    
    func getCareInfoList(param: GetCareInfoRequestParam) -> Single<GetCareInfoEntity> {
        return careDataStore.getCareInfoList(param: param)
    }
    
    func setCareInfoList(param: SetCareInfoRequestParam) -> Single<GetCareInfoEntity> {
        return careDataStore.setCareInfoList(param: param)
    }
    
    func deleteCareInfoList(param: DeleteCareInfoRequestParam) -> Single<GetCareInfoEntity> {
        return careDataStore.deleteCareInfoList(param: param)
    }
}
