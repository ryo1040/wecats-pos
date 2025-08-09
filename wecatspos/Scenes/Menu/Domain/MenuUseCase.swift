//
//  MenuUseCase.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//

import Foundation
//import RxSwift

protocol HomeUseCaseProtocol: AnyObject {

}

final class HomeUseCase: HomeUseCaseProtocol {
    
//    private var homeRepository: HomeRepositoryProtocol!
//    private var userDefaultRepository: UserDefaultRepositoryProtocol!
//    private var commonRepository: CommonRepositoryProtocol!
//    
//    init(homeRepository: HomeRepositoryProtocol, userDefaultRepository: UserDefaultRepositoryProtocol, commonRepository: CommonRepositoryProtocol) {
//        self.homeRepository = homeRepository
//        self.userDefaultRepository = userDefaultRepository
//        self.commonRepository = commonRepository
//    }
//    
//    func getHome(param: GetHomeRequestParam) -> Observable<GetHomeModel>{
//        self.homeRepository.getHome(param: param).asObservable().map{ entity in
//            GetHomeTranslator.generate(getHomeEntity: entity)
//        }
//    }
//    
//    func getBusinessday() -> Observable<GetBusinessdayModel> {
//        self.homeRepository.getBusinessday().asObservable().map{ entity in
//            GetBusinessdayTranslator.generate(getBusinessdayEntity: entity)
//        }
//    }
//    
//    func getFloor() -> Observable<GetFloorModel> {
//        self.commonRepository.getFloor().asObservable().map{ entity in
//            GetFloorTranslator.generate(getFloorEntity: entity)
//        }
//    }
//    
//    func getReservation(param: GetReservationRequestParam) -> Observable<GetReservationModel> {
//        self.homeRepository.getReservation(param: param).asObservable().map{ entity in
//            GetReservationTranslator.generate(getReservationEntity: entity)
//        }
//    }
//    
//    func changeStatus(param: PostStatusRequestParam) -> Observable<PostStatusModel> {
//        self.homeRepository.changeStatus(param: param).asObservable().map { entity in
//            PostStatusTranslator.generate(postStatusEntity: entity)
//        }
//    }
//    
//    func setReservation(param: PostReservationRequestParam) -> Observable<PostReservationResponseModel> {
//        self.homeRepository.setReservation(param: param).asObservable().map { entity in
//            PostReservationTranslator.generate(postReservationEntity: entity)
//        }
//    }
//    
//    func changeReservation(param: PostReservationRequestParam) -> Observable<PostReservationResponseModel> {
//        self.homeRepository.changeReservation(param: param).asObservable().map { entity in
//            PostReservationTranslator.generate(postReservationEntity: entity)
//        }
//    }
//    
//    func cancelReservation(param: PostReservationRequestParam) -> Observable<PostReservationResponseModel> {
//        self.homeRepository.cancelReservation(param: param).asObservable().map { entity in PostReservationTranslator.generate(postReservationEntity: entity)
//        }
//    }
//    
//    func updateReservation(param: PostReservationRequestParam) -> Observable<PostReservationResponseModel> {
//        self.homeRepository.updateReservation(param: param).asObservable().map { entity in
//            PostReservationTranslator.generate(postReservationEntity: entity)
//        }
//    }
//    
//    func setFreeInput(param: PostReservationRequestParam) -> Observable<PostReservationResponseModel> {
//        self.homeRepository.setFreeInput(param: param).asObservable().map { entity in
//            PostReservationTranslator.generate(postReservationEntity: entity)
//        }
//    }
//    
//    func searchReservation(param: GetSearchReservationRequestParam) -> Observable<GetSearchReservationModel> {
//        self.homeRepository.getSearchReservation(param: param).asObservable().map{ entity in
//            GetSearchReservationTranslator.generate(getSearchReservationEntity: entity)
//        }
//    }
//    
//    func getUserInfo() -> UserInfoModel {
//        return UserInfoModel(userId: self.userDefaultRepository.userId, department: self.userDefaultRepository.department, name: self.userDefaultRepository.name, floorId: self.userDefaultRepository.floorId, floorName: self.userDefaultRepository.floorName)
//    }
//    
//    func getEntranceMode() -> Bool {
//        return self.userDefaultRepository.entranceMode
//    }
//    
//    func getAutoReloadInterval() -> Double {
//        let autoReloadInterval = self.userDefaultRepository.settings.filter({ $0.key == "auto_reload_interval" })
//        var autoReloadIntervalValue: Double = 1800
//        if autoReloadInterval.count != 0 {
//          if Double(autoReloadInterval[0].value) != nil {
//            autoReloadIntervalValue = Double(autoReloadInterval[0].value)!
//          }
//        }
//        return autoReloadIntervalValue
//      }
//    
//    func getDepartment() -> Observable<GetDepartmentModel> {
//        self.homeRepository.getDepartment()
//            .asObservable()
//            .map { entity in
//                return GetDepartmentTranslator.generate(getDepartmentEntity: entity)
//            }
//    }
}
