//
//  CarePresenter.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import Foundation
import UIKit
import RxSwift

protocol CarePresenterProtocol: AnyObject {
    var viewCareInfo: PublishSubject<[CareInfoModel]> { get }
    func load(careType: Int)
    func didTapMenuButton()
    func setCareInfo(selectedCareType: Int, selectedRow: CareInfoModel)
    func deleteCareInfo(selectedCareType: Int, selectedRow: CareInfoModel)
}

final class CarePresenter: CarePresenterProtocol {
    
    var viewController = CareViewController()
    
    private let wireframe: CareWireframeProtocol!
    private let useCase: CareUseCaseProtocol!
    
    private(set) var viewCareInfo = PublishSubject<[CareInfoModel]>()
    
    private let disposeBag = DisposeBag()
    
    init(wireframe: CareWireframeProtocol, useCase: CareUseCaseProtocol) {
        self.wireframe = wireframe
        self.useCase = useCase
    }
    
    func load(careType: Int) {
        let param = GetCareInfoRequestParam(careType: careType)

        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getCareInfoList(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                print(model)
                self.viewCareInfo.onNext(model)
            }, onError: { error in
                self.handleLoadError(error, careType: careType)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleLoadError(_ error: Error, careType: Int) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.load(careType: careType)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func didTapMenuButton() {
        wireframe.presentMenu()
    }
    
    func setCareInfo(selectedCareType: Int, selectedRow: CareInfoModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let param = SetCareInfoRequestParam(catId: selectedRow.catId, careType: selectedCareType, careDate: formatter.string(from: Date()), memo: selectedRow.memo)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.setCareInfoList(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                print(model)
                self.viewCareInfo.onNext(model)
            }, onError: { error in
                self.handleSetCareInfoError(error, selectedCareType: selectedCareType, selectedRow: selectedRow)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleSetCareInfoError(_ error: Error, selectedCareType: Int, selectedRow: CareInfoModel) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.setCareInfo(selectedCareType: selectedCareType, selectedRow: selectedRow)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func deleteCareInfo(selectedCareType: Int, selectedRow: CareInfoModel) {
        let param = DeleteCareInfoRequestParam(catId: selectedRow.catId, careType: selectedCareType, branch: selectedRow.branch)
        
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.deleteCareInfoList(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                print(model)
                self.viewCareInfo.onNext(model)
            }, onError: { error in
                self.handleLoadError(error, careType: selectedCareType)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDeleteCareInfoError(_ error: Error, selectedCareType: Int, selectedRow: CareInfoModel) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.deleteCareInfo(selectedCareType: selectedCareType, selectedRow: selectedRow)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
