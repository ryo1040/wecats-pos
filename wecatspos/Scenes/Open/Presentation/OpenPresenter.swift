//
//  OpenPresenter.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/03.
//

import Foundation
import UIKit
import RxSwift

protocol OpenPresenterProtocol: AnyObject {
    var viewGuestInfo: PublishSubject<[GuestInfoModel]> { get }
    var viewEntry: PublishSubject<[GuestInfoModel]> { get }
    var viewLeave: PublishSubject<[GuestInfoModel]> { get }
    func load()
    func checkDay(date: Date) -> Int
    func didTapMenuButton()
    func didTapEnterSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String)
    func didTapUpdateSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String)
    func didTapLeaveSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String)
    func didTapDeleteButton(id: Int, date: String)
    func didTapEditVisitorInfoUpdateButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String)
}

final class OpenPresenter: OpenPresenterProtocol {
    
    var viewController = OpenViewController()

    private let wireframe: OpenWireframeProtocol!
    private let useCase: OpenUseCaseProtocol!
    
    private(set) var viewGuestInfo = PublishSubject<[GuestInfoModel]>()
    private(set) var viewEntry = PublishSubject<[GuestInfoModel]>()
    private(set) var viewLeave = PublishSubject<[GuestInfoModel]>()
    
    private let disposeBag = DisposeBag()
    
    init(wireframe: OpenWireframeProtocol, useCase: OpenUseCaseProtocol) {
        self.wireframe = wireframe
        self.useCase = useCase
    }
    
    func load(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let param = GetGuestInfoRequestParam(date: formatter.string(from: Date()))
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getGuestInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewGuestInfo.onNext(model)
            }, onError: { error in
                self.handleLoadError(error)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleLoadError(_ error: Error) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.load()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func checkDay(date: Date) -> Int {
        self.useCase.checkDay(date: date)
    }
    
    func didTapMenuButton() {
        wireframe.presentMenu()
    }
    
    func didTapEnterSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String) {
        let param = PostGuestInfoRequestParam(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsdayFlag, enterTime: enterTime, leftTime: "", stayTime: 0, adultCount: countAdult, childCount: countChild, calcAmount: 0, discountAmount: 0, salesAmount: 0, gachaAmount: 0, totalAmount: 0, stayingFlag: true, memo: memo)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.setGuestInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewEntry.onNext(model)
            }, onError: { error in
                self.handleDidTapEnterSubmitButtonError(error, id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTime, countAdult: countAdult, countChild: countChild, memo: memo)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapEnterSubmitButtonError(_ error: Error, id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapEnterSubmitButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTime, countAdult: countAdult, countChild: countChild, memo: memo)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapUpdateSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String) {
        let param = PostGuestInfoRequestParam(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsdayFlag, enterTime: enterTime, leftTime: "", stayTime: 0, adultCount: countAdult, childCount: countChild, calcAmount: 0, discountAmount: 0, salesAmount: 0, gachaAmount: 0, totalAmount: 0, stayingFlag: true, memo: memo)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.updateGuestInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewEntry.onNext(model)
            }, onError: { error in
                self.handleDidTapUpdateSubmitButtonError(error, id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTime, countAdult: countAdult, countChild: countChild, memo: memo)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapUpdateSubmitButtonError(_ error: Error, id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapUpdateSubmitButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTime, countAdult: countAdult, countChild: countChild, memo: memo)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapLeaveSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String) {
        let param = PostGuestInfoRequestParam(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name ?? "", date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, adultCount: adultCount, childCount: childCount, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, stayingFlag: false, memo: memo)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.updateGuestInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewLeave.onNext(model)
            }, onError: { error in
                self.handleDidTapLeaveSubmitButtonError(error, id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapLeaveSubmitButtonError(_ error: Error, id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapLeaveSubmitButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
                }
            })
            .disposed(by: self.disposeBag)
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
            }, onError: { error in
                self.handleDidTapDeleteButtonError(error, id: id, date: date)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapDeleteButtonError(_ error: Error, id: Int, date: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapDeleteButton(id: id, date: date)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapEditVisitorInfoUpdateButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String){
        let param = PostGuestInfoRequestParam(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name!, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, adultCount: adultCount, childCount: childCount, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, stayingFlag: false, memo: memo)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.updateGuestInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewEntry.onNext(model)
            }, onError: { error in
                self.handleDidTapEditVisitorInfoUpdateButtonError(error, id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapEditVisitorInfoUpdateButtonError(_ error: Error, id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, salesAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapEditVisitorInfoUpdateButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: salesAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
