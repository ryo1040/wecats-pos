//
//  TotalPresenter.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/09.
//

import Foundation
import UIKit
import RxSwift

protocol TotalPresenterProtocol: AnyObject {
    var viewGuestInfo: PublishSubject<[GuestInfoModel]> { get }
    var viewTotalAmountList: PublishSubject<[TotalAmountListModel]> { get }
    var viewSales: PublishSubject<GetSalesModel> { get }
    var getReservationNightInfo: PublishSubject<ReservationNightViewModel> { get }
    func load(date: String)
    func getTotalAmountList(month: String)
    func didTapMenuButton()
    func didTapDeleteButton(id: Int, date: String)
    func didTapEditVisitorInfoUpdateButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, saleAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String)
    func getSales(date: String)
    func getReservationNightInfo(date: String, name: String)
    func didTapReservationNightSubmitButton(id: Int, branch: Int, date: String, name: String, tel: String, count: Int, price: Int, memo: String, visitorHistoryId: Int)
    func didTapReservationNightDeleteButton(id: Int, branch: Int, date: String, visitorHistoryId: Int)
}

final class TotalPresenter: TotalPresenterProtocol {
    
    var viewController = TotalViewController()
    
    private let wireframe: TotalWireframeProtocol!
    private let useCase: TotalUseCaseProtocol!
    
    private(set) var viewGuestInfo = PublishSubject<[GuestInfoModel]>()
    private(set) var viewTotalAmountList = PublishSubject<[TotalAmountListModel]>()
    private(set) var viewSales = PublishSubject<GetSalesModel>()
    private(set) var getReservationNightInfo = PublishSubject<ReservationNightViewModel>()
    
    private let disposeBag = DisposeBag()
    
    init(wireframe: TotalWireframeProtocol, useCase: TotalUseCaseProtocol) {
        self.wireframe = wireframe
        self.useCase = useCase
    }
    
    func load(date: String){
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getGuestInfo(param: GetGuestInfoRequestParam(date: date))
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewGuestInfo.onNext(model)
            }, onError: { [unowned self] error in
                self.handleLoadError(error, date: date)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleLoadError(_ error: Error, date: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.load(date: date)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func getTotalAmountList(month: String) {
        let param = GetTotalAmountListRequestParam(month: month)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getTotalAmountList(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewTotalAmountList.onNext(model)
            }, onError: { [unowned self] error in
                self.handleGetTotalAmountListError(error, month: month)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleGetTotalAmountListError(_ error: Error, month: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.getTotalAmountList(month: month)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapMenuButton() {
        wireframe.presentMenu()
    }
    
    func didTapDeleteButton(id: Int, date: String) {
        let param = PostDeleteGuestInfoRequestParam(id: id, date: date)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.deleteGuestInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewGuestInfo.onNext(model)
            }, onError: { [unowned self] error in
                self.handleDidTapDeleteButtonError(error, id: id, date: date)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapDeleteButtonError(_ error: Error, id: Int, date: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapDeleteButton(id: id, date: date)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapEditVisitorInfoUpdateButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, saleAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String){
        let param = PostGuestInfoRequestParam(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name!, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, adultCount: adultCount, childCount: childCount, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: saleAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, stayingFlag: false, memo: memo)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.updateGuestInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewGuestInfo.onNext(model)
            }, onError: { [unowned self] error in
                self.handleDidTapEditVisitorInfoUpdateButtonError(error, id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, saleAmount: saleAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapEditVisitorInfoUpdateButtonError(_ error: Error, id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, saleAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapEditVisitorInfoUpdateButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, saleAmount: saleAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func getSales(date: String) {
        let param = GetSalesMasterRequestParam(date: date)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getSales(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewSales.onNext(model)
            }, onError: { [unowned self] error in
                self.handleGetSalesMasterError(error, date: date)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleGetSalesMasterError(_ error: Error, date: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.getSales(date: date)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func getReservationNightInfo(date: String, name: String) {
        let param = GetReservationNightRequestParam(date: date, name: name)
            
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getReservationNightInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.getReservationNightInfo.onNext(model.reservationNightViewModel[0])
            }, onError: { [unowned self] error in
                self.handleGetReservationNightInfoError(error, date: date, name: name)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleGetReservationNightInfoError(_ error: Error, date: String, name: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.getReservationNightInfo(date: date, name: name)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapReservationNightSubmitButton(id: Int, branch: Int, date: String, name: String, tel: String, count: Int, price: Int, memo: String, visitorHistoryId: Int) {
        let param = PostReservationNightRequestParam(id: id, branch: branch, reservationType: 1, date: date, name: name, tel: tel, count: count, price: price, memo: memo, visitorHistoryId: visitorHistoryId)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.setReservationNightInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewGuestInfo.onNext(model)
            }, onError: { [unowned self] error in
                self.handleDidTapeservationNightSubmitButtonError(error, id: id, branch: branch, date: date, name: name, tel: tel, count: count, price: price, memo: memo, visitorHistoryId: visitorHistoryId)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapeservationNightSubmitButtonError(_ error: Error, id: Int, branch: Int, date: String, name: String, tel: String, count: Int, price: Int, memo: String, visitorHistoryId: Int) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapReservationNightSubmitButton(id: id, branch: branch, date: date, name: name, tel: tel, count: count, price: price, memo: memo, visitorHistoryId: visitorHistoryId)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapReservationNightDeleteButton(id: Int, branch: Int, date: String, visitorHistoryId: Int) {
        let param = PostDeleteReservationNightRequestParam(id: id, branch: branch, date: date, visitorHistoryId: visitorHistoryId)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.deleteReservationNightInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewGuestInfo.onNext(model)
            }, onError: { [unowned self] error in
                self.handleDidTapeservationNightDeleteButtonError(error, id: id, branch: branch, date: date, visitorHistoryId: visitorHistoryId)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapeservationNightDeleteButtonError(_ error: Error, id: Int, branch: Int, date: String, visitorHistoryId: Int) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapReservationNightDeleteButton(id: id, branch: branch, date: date, visitorHistoryId: visitorHistoryId)
                }
            })
            .disposed(by: self.disposeBag)
    }
}

