//
//  OpenRepository.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/05.
//

import Foundation
import RxSwift

protocol OpenRepositoryProtocol {
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func setGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Single<GetGuestInfoEntity>
}

final class OpenRepository: OpenRepositoryProtocol {
    lazy var openDataStore = OpenDataStoreFactory.createOpenDataStore()
    
    func getGuestInfo(param: GetGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.getGuestInfo(param: param)
    }
    
    func setGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.setGuestInfo(param: param)
    }
    
    func updateGuestInfo(param: PostGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.updateGuestInfo(param: param)
    }
    
    func deleteGuestInfo(param: PostDeleteGuestInfoRequestParam) -> Single<GetGuestInfoEntity> {
        return openDataStore.deleteGuestInfo(param: param)
    }
}
