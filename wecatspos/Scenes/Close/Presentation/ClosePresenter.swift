//
//  ClosePresenter.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/19.
//

import Foundation
import UIKit
import RxSwift

protocol ClosePresenterProtocol: AnyObject {
    var viewCloseResister: PublishSubject<[DenominationModel]> { get }
    var viewCheckResult: PublishSubject<Int> { get }
    func load(month: String)
    func didTapMenuButton()
    func checkTotalAmount(date: String, totalAmount: Int, ticketAmount: Int, exportAmount: Int)
    func didTapDenominationSubmitButton(date: String, tenThousandYenCount: Int, fiveThousandYenCount: Int, twoThousandYenCount: Int, oneThousandYenCount: Int, fiveHundredYenCount: Int, oneHundredYenCount: Int, fiftyYenCount: Int, tenYenCount: Int, fiveYenCount: Int, oneYenCount: Int, exportAmount: Int, ticketAmount: Int, totalAmount: Int, memo: String)
    func didTapDenominationDeleteButton(date: String)
}

final class ClosePresenter: ClosePresenterProtocol {
    
    var viewController = CloseViewController()
    
    private let wireframe: CloseWireframeProtocol!
    private let useCase: CloseUseCaseProtocol!
    
    private(set) var viewCloseResister = PublishSubject<[DenominationModel]>()
    private(set) var viewCheckResult = PublishSubject<Int>()
    
    private let disposeBag = DisposeBag()
    
    init(wireframe: CloseWireframeProtocol, useCase: CloseUseCaseProtocol) {
        self.wireframe = wireframe
        self.useCase = useCase
    }
    
    func load(month: String) {
        let param = GetDenominationRequestParam(month: month)

        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getDenominationList(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewCloseResister.onNext(model)
            }, onError: { error in
                self.handleLoadError(error, month: month)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleLoadError(_ error: Error, month: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.load(month: month)
                }
            })
            .disposed(by: self.disposeBag)
    }

    func didTapMenuButton() {
        wireframe.presentMenu()
    }
    
    func checkTotalAmount(date: String, totalAmount: Int, ticketAmount: Int, exportAmount: Int) {
        let param = PostCheckTotalAmountRequestParam(date: date, totalAmount: totalAmount, ticketAmount: ticketAmount, exportAmount: exportAmount)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.checkTotalAmount(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                // 返ってきたチェック結果をポップアップで表示
                if model.status == 200 {
                    self.wireframe.presentAlert(model.checkResult, buttonTitle: "確認")
                        .subscribe(onNext: { option in
                            if option == "確認" {
                                self.viewCheckResult.onNext(model.status)
                            }
                        })
                        .disposed(by: self.disposeBag)
                } else if model.status == 901 {
                    self.wireframe.presentAlert(model.checkResult, buttonTitle: "確認")
                        .subscribe(onNext: { option in
                            if option == "確認" {
                                self.viewCheckResult.onNext(model.status)
                            }
                        })
                        .disposed(by: self.disposeBag)
                }

            }, onError: { error in
                self.handleCheckTotalAmountError(error, date: date, totalAmount: totalAmount, ticketAmount: ticketAmount, exportAmount: exportAmount)
                print(error)
            })
            .disposed(by: self.disposeBag)

    }
    
    func handleCheckTotalAmountError(_ error: Error, date: String, totalAmount: Int, ticketAmount: Int, exportAmount: Int) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.checkTotalAmount(date: date, totalAmount: totalAmount, ticketAmount: ticketAmount, exportAmount: exportAmount)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapDenominationSubmitButton(date: String, tenThousandYenCount: Int, fiveThousandYenCount: Int, twoThousandYenCount: Int, oneThousandYenCount: Int, fiveHundredYenCount: Int, oneHundredYenCount: Int, fiftyYenCount: Int, tenYenCount: Int, fiveYenCount: Int, oneYenCount: Int, exportAmount: Int, ticketAmount: Int, totalAmount: Int, memo: String) {
        let param = PostDenominationRequestParam(date: date, tenThousandYenCount: tenThousandYenCount, fiveThousandYenCount: fiveThousandYenCount, twoThousandYenCount: twoThousandYenCount, oneThousandYenCount: oneThousandYenCount, fiveHundredYenCount: fiveHundredYenCount, oneHundredYenCount: oneHundredYenCount, fiftyYenCount: fiftyYenCount, tenYenCount: tenYenCount, fiveYenCount: fiveYenCount, oneYenCount: oneYenCount, exportAmount: exportAmount, ticketAmount: ticketAmount, totalAmount: totalAmount, memo: memo)

        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.setDenominaiton(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewCloseResister.onNext(model)
            }, onError: { error in
                self.handleSetDenominationError(error, date: date, tenThousandYenCount: tenThousandYenCount, fiveThousandYenCount: fiveThousandYenCount, twoThousandYenCount: twoThousandYenCount, oneThousandYenCount: oneThousandYenCount, fiveHundredYenCount: fiveHundredYenCount, oneHundredYenCount: oneHundredYenCount, fiftyYenCount: fiftyYenCount, tenYenCount: tenYenCount, fiveYenCount: fiveYenCount, oneYenCount: oneYenCount, exportAmount: exportAmount, ticketAmount: ticketAmount, totalAmount: totalAmount, memo: memo)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleSetDenominationError(_ error: Error, date: String, tenThousandYenCount: Int, fiveThousandYenCount: Int, twoThousandYenCount: Int, oneThousandYenCount: Int, fiveHundredYenCount: Int, oneHundredYenCount: Int, fiftyYenCount: Int, tenYenCount: Int, fiveYenCount: Int, oneYenCount: Int, exportAmount: Int, ticketAmount: Int, totalAmount: Int, memo: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapDenominationSubmitButton(date: date, tenThousandYenCount: tenThousandYenCount, fiveThousandYenCount: fiveThousandYenCount, twoThousandYenCount: twoThousandYenCount, oneThousandYenCount: oneThousandYenCount, fiveHundredYenCount: fiveHundredYenCount, oneHundredYenCount: oneHundredYenCount, fiftyYenCount: fiftyYenCount, tenYenCount: tenYenCount, fiveYenCount: fiveYenCount, oneYenCount: oneYenCount, exportAmount: exportAmount, ticketAmount: ticketAmount, totalAmount: totalAmount, memo: memo)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapDenominationDeleteButton(date: String) {
        let param = PostDenominationDeleteRequestParam(date: date)

        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.deleteDenominaiton(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewCloseResister.onNext(model)
            }, onError: { error in
                self.handleDeleteDenominationError(error, date: date)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDeleteDenominationError(_ error: Error, date: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapDenominationDeleteButton(date: date)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
