//
//  BaseWireframe.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//

import Foundation
import RxSwift

protocol BaseWireframeProtocol {
    func presentAlert(_ message: String, buttonTitle: String) -> Observable<String>
    func presentErrorAlert(_ errorType: AppErrorTypeProtocol?) -> Observable<AppErrorUserOption>
    func presentAlert(
        _ title: String?,
        _ message: String?,
        cancelActionTitle: String?,
        actionTitles: [String]
    ) -> Observable<String>
}

class BaseWireframe: BaseWireframeProtocol {
    func presentAlert(_ message: String = "", buttonTitle: String) -> Observable<String> {
        return Observable.create { observer in
            DefaultWireframe.shared.presentAlert(
                message,
                buttonTitle: buttonTitle)
            .subscribe(onNext: { option in
                observer.on(.next(option))
            })
        }
    }
    
    func presentErrorAlert(_ errorType: AppErrorTypeProtocol?) -> Observable<AppErrorUserOption> {
        return Observable.create { observer in
            DefaultWireframe.shared
                .presentErrorAlert(errorType)
                .subscribe(onNext: { option in
                    observer.on(.next(option))
                })
        }
    }
    
    func presentAlert(_ title: String?, _ message: String?, cancelActionTitle: String?, actionTitles: [String]) -> Observable<String> {
        return Observable.create { observer in
            DefaultWireframe.shared.presentAlert(title, message, cancelActionTitle: cancelActionTitle, actionTitles: actionTitles).subscribe(onNext: { option in
                observer.on(.next(option))
            })
        }
    }
}

