//
//  SettingsPresenter.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import UIKit
import RxSwift

protocol SettingsPresenterProtocol: AnyObject {
    var viewSales: PublishSubject<GetSalesModel> { get }
    func load()
    func didTapMenuButton()
    func setSalesMaster(salesMaster: SalesMasterModel)
    func deleteSalesMaster(selectedSalesMaster: SalesMasterModel)
}

final class SettingsPresenter: SettingsPresenterProtocol {
    
    var viewController = SettingsViewController()
    
    private let wireframe: SettingsWireframeProtocol!
    private let useCase: SettingsUseCaseProtocol!
    
    private(set) var viewSales = PublishSubject<GetSalesModel>()
    
    private let disposeBag = DisposeBag()
    
    init(wireframe: SettingsWireframeProtocol, useCase: SettingsUseCaseProtocol) {
        self.wireframe = wireframe
        self.useCase = useCase
    }
    
    func load() {
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getSalesMaster()
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewSales.onNext(model)
            }, onError: { error in
                self.handleLoadError(error)
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
    
    func didTapMenuButton() {
        wireframe.presentMenu()
    }
    
    func setSalesMaster(salesMaster: SalesMasterModel) {
        let param = PostSalesMasterRequestParam(id: salesMaster.id, name: salesMaster.name, price: salesMaster.price, order: salesMaster.order, memo: salesMaster.memo)

        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.setSalesMaster(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
//                self.viewCloseResister.onNext(model)
            }, onError: { error in
                self.handleSetSalesMasterError(error, salesMaster: salesMaster)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleSetSalesMasterError(_ error: Error, salesMaster: SalesMasterModel) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.setSalesMaster(salesMaster: salesMaster)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func deleteSalesMaster(selectedSalesMaster: SalesMasterModel) {
        let param = PostSalesMasterRequestParam(id: selectedSalesMaster.id, name: selectedSalesMaster.name, price: selectedSalesMaster.price, order: selectedSalesMaster.order, memo: selectedSalesMaster.memo)

        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.deleteSalesMaster(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
//                self.viewCloseResister.onNext(model)
            }, onError: { error in
                self.handleDeleteSalesMasterError(error, selectedSalesMaster: selectedSalesMaster)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDeleteSalesMasterError(_ error: Error, selectedSalesMaster: SalesMasterModel) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.deleteSalesMaster(selectedSalesMaster: selectedSalesMaster)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
