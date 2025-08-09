//
//  CatInfoPresenter.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/29.
//

import Foundation
import RxSwift
import UIKit

protocol CatInfoPresenterProtocol: AnyObject {
    var viewCatInfoData: PublishSubject<[CatInfoModel]> { get }
    var viewMedicalHistoryData: PublishSubject<[MedicalHistoryModel]> { get }
    func load()
    func didTapMenuButton()
    func didTapEditMedicalHistorySubmitButton(id: Int, catId: Int, date: String, overview: String, detail: String?)
    func getMedicalHistory(catId: Int)
}

final class CatInfoPresenter: CatInfoPresenterProtocol {

    var viewController = CatInfoViewController()
    private let wireframe: CatInfoWireframeProtocol!
    private let useCase: CatInfoUseCaseProtocol!
    
    private(set) var viewCatInfoData = PublishSubject<[CatInfoModel]>()
    private(set) var viewMedicalHistoryData = PublishSubject<[MedicalHistoryModel]>()
    
    private let disposeBag = DisposeBag()
    
    init(useCase: CatInfoUseCaseProtocol, wireframe: CatInfoWireframeProtocol) {
        self.useCase = useCase
        self.wireframe = wireframe
    }
    
    func load() {
        self.getCatInfo()
    }
    
    func didTapMenuButton() {
        wireframe.presentMenu()
    }
    
    func didTapEditMedicalHistorySubmitButton(id: Int, catId: Int, date: String, overview: String, detail: String?) {
        let param = PostMedicalHistoryRequestParam(id: id, catId: catId, date: date, reason: overview, treatment: detail ?? "")

        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.setMedicalHistory(param: param)
            }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewMedicalHistoryData.onNext(model)
            }, onError: { error in
                self.handleDidTapEditMedicalHistorySubmitButtonError(error, id: id, catId: catId, date: date, overview: overview, detail: detail)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleDidTapEditMedicalHistorySubmitButtonError(_ error: Error, id: Int, catId: Int, date: String, overview: String, detail: String?) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.didTapEditMedicalHistorySubmitButton(id: id, catId: catId, date: date, overview: overview, detail: detail)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func getMedicalHistory(catId: Int) {
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getMedicalHistory(param: GetMedicalHistoryRequestParam(catId: catId)) }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewMedicalHistoryData.onNext(model)
            }, onError: { error in
                self.handleGetMedicalHistoryError(error, catId: catId)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleGetMedicalHistoryError(_ error: Error, catId: Int) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.getMedicalHistory(catId: catId)
                }
            })
            .disposed(by: self.disposeBag)
    }
}

private extension CatInfoPresenter {
    
    func getCatInfo() {
        Observable.just(Void())
            .flatMap { [unowned self] in
                self.useCase.getCatInfo() }
            .subscribe(onNext: {
                [unowned self] model in
                self.viewCatInfoData.onNext(model)
            }, onError: { error in
                self.handleGetCatInfoError(error)
                print(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    func handleGetCatInfoError(_ error: Error) {
        self.wireframe.presentAlert(Sentence.MSG_NETWORK_ERROR, buttonTitle: Sentence.DIALOG_BTN_RETRY)
            .subscribe(onNext: { option in
                if option == Sentence.DIALOG_BTN_RETRY {
                    // ボタンタップ時に再試行
                    self.getCatInfo()
                }
            })
            .disposed(by: self.disposeBag)
    }
}
