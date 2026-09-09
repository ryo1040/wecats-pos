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
    var calcedTotalAmount: PublishSubject<GetTotalAmountModel> { get }
    var viewSales: PublishSubject<GetSalesModel> { get }
    var salesRegistrationCompleted: PublishSubject<Void> { get }
    var getReservationNightInfo: PublishSubject<ReservationNightViewModel> { get }
    func load()
    func checkDay(date: Date) -> Int
    func didTapMenuButton()
    func didTapEnterSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String)
    func didTapUpdateSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String)
    func didTapLeaveSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, saleAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String)
    func didTapDeleteButton(id: Int, date: String)
    func didTapEditVisitorInfoUpdateButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, saleAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String)
    func calcTotalAmount(enterTime: String, leftTime: String, adultCount: Int, childCount: Int, discountAmount: String, freeNyanTime: Bool, saleAmount: String)
    func getSales(date: String)
    func didTapSalesRegisterButton(sales: [SalesModel], totalAmount: Int)
    func getReservationNightInfo(date: String, name: String)
    func didTapReservationNightSubmitButton(id: Int, branch: Int, date: String, name: String, tel: String, count: Int, price: Int, memo: String, visitorHistoryId: Int)
    func didTapReservationNightDeleteButton(id: Int, branch: Int, date: String, visitorHistoryId: Int)
}

final class OpenPresenter: OpenPresenterProtocol {
    
    var viewController = OpenViewController()

    private let wireframe: OpenWireframeProtocol!
    private let useCase: OpenUseCaseProtocol!
    
    private(set) var viewGuestInfo = PublishSubject<[GuestInfoModel]>()
    private(set) var viewEntry = PublishSubject<[GuestInfoModel]>()
    private(set) var viewLeave = PublishSubject<[GuestInfoModel]>()
    private(set) var calcedTotalAmount = PublishSubject<GetTotalAmountModel>()
    private(set) var viewSales = PublishSubject<GetSalesModel>()
    private(set) var salesRegistrationCompleted = PublishSubject<Void>()
    private(set) var getReservationNightInfo = PublishSubject<ReservationNightViewModel>()
    
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
            }, onError: { [unowned self] error in
                self.handleLoadError(error)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleLoadError(_ error: Error) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
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
            }, onError: { [unowned self] error in
                self.handleDidTapEnterSubmitButtonError(error, id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTime, countAdult: countAdult, countChild: countChild, memo: memo)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapEnterSubmitButtonError(_ error: Error, id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
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
            }, onError: { [unowned self] error in
                self.handleDidTapUpdateSubmitButtonError(error, id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTime, countAdult: countAdult, countChild: countChild, memo: memo)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapUpdateSubmitButtonError(_ error: Error, id: Int, repeatFlag: Bool, patternId: Int, name: String, date: String, holidayFlag: Bool, kidsdayFlag: Bool, enterTime: String, countAdult: Int, countChild: Int, memo: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapUpdateSubmitButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsdayFlag: kidsdayFlag, enterTime: enterTime, countAdult: countAdult, countChild: countChild, memo: memo)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapLeaveSubmitButton(id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, saleAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String) {
        let param = PostGuestInfoRequestParam(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name ?? "", date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, adultCount: adultCount, childCount: childCount, calcAmount: calcAmount, discountAmount: discountAmount, salesAmount: saleAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, stayingFlag: false, memo: memo)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.updateGuestInfo(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewLeave.onNext(model)
            }, onError: { [unowned self] error in
                self.handleDidTapLeaveSubmitButtonError(error, id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, saleAmount: saleAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapLeaveSubmitButtonError(_ error: Error, id: Int, repeatFlag: Bool, patternId: Int, name: String?, date: String, holidayFlag: Bool, kidsDayFlag: Bool, adultCount: Int, childCount: Int, enterTime: String, leftTime: String, stayTime: Int, calcAmount: Int, discountAmount: Int, saleAmount: Int, gachaAmount: Int, totalAmount: Int, memo: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapLeaveSubmitButton(id: id, repeatFlag: repeatFlag, patternId: patternId, name: name, date: date, holidayFlag: holidayFlag, kidsDayFlag: kidsDayFlag, adultCount: adultCount, childCount: childCount, enterTime: enterTime, leftTime: leftTime, stayTime: stayTime, calcAmount: calcAmount, discountAmount: discountAmount, saleAmount: saleAmount, gachaAmount: gachaAmount, totalAmount: totalAmount, memo: memo)
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
                self.viewEntry.onNext(model)
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
    
    func calcTotalAmount(enterTime: String, leftTime: String, adultCount: Int, childCount: Int, discountAmount: String, freeNyanTime: Bool, saleAmount: String) {
        let param = GetCalcTotalAmountRequestParam(enterTime: enterTime, leftTime: leftTime, adultCount: adultCount, childCount: childCount, discountAmount: discountAmount, freeNyanTime: freeNyanTime, salesAmount: saleAmount)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.calcTotalAmount(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.calcedTotalAmount.onNext(model)
            }, onError: { [unowned self] error in
                self.handleCalcTotalAmountError(error, enterTime: enterTime, leftTime: leftTime, adultCount: adultCount, childCount: childCount, discountAmount: discountAmount, freeNyanTime: freeNyanTime, saleAmount: saleAmount)
            })
            .disposed(by: self.disposeBag)
    }

    func handleCalcTotalAmountError(_ error: Error, enterTime: String, leftTime: String, adultCount: Int, childCount: Int, discountAmount: String, freeNyanTime: Bool, saleAmount: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.calcTotalAmount(enterTime: enterTime, leftTime: leftTime, adultCount: adultCount, childCount: childCount, discountAmount: discountAmount ,freeNyanTime: freeNyanTime, saleAmount: saleAmount)
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
    
    func didTapSalesRegisterButton(sales: [SalesModel], totalAmount: Int) {
        let requestSales = sales.map {
            PostSalesRequestSales(
                date: $0.date,
                salesMasterId: $0.salesMasterId,
                branch: $0.branch,
                count: $0.count
            )
        }
        let param = PostSalesRequestParam(sales: requestSales, totalAmount: totalAmount)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.setSales(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.salesRegistrationCompleted.onNext(())
            }, onError: { [unowned self] error in
                self.handleDidTapSalesRegisterButtonError(error, sales: sales, totalAmount: totalAmount)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapSalesRegisterButtonError(_ error: Error, sales: [SalesModel], totalAmount: Int) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { [unowned self] option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapSalesRegisterButton(sales: sales, totalAmount: totalAmount)
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
                self.viewLeave.onNext(model)
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
                self.viewLeave.onNext(model)
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
