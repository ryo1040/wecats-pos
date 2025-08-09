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
    func load(date: String)
    func getTotalAmountList(month: String)
    func didTapMenuButton()
}

final class TotalPresenter: TotalPresenterProtocol {
    
    var viewController = TotalViewController()
    
    private let wireframe: TotalWireframeProtocol!
    private let useCase: TotalUseCaseProtocol!
    
    private(set) var viewGuestInfo = PublishSubject<[GuestInfoModel]>()
    private(set) var viewTotalAmountList = PublishSubject<[TotalAmountListModel]>()
    
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
            }, onError: { error in
                self.handleLoadError(error, date: date)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleLoadError(_ error: Error, date: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
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
            }, onError: { error in
                self.handleGetTotalAmountListError(error, month: month)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleGetTotalAmountListError(_ error: Error, month: String) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
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
}
