//
//  DefaultWireframe.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//

import Foundation
import UIKit
import RxSwift

protocol DefaultWireframeProtocol {
}

final class DefaultWireframe: NSObject, DefaultWireframeProtocol {
    static let shared = DefaultWireframe()
//    let disposeBag = DisposeBag()

//    var departmentData: [DepartmentModel] = []
//    var selectedRow: Int = 0
//    var currentTextField: UITextField?
//        
    func showRoot(window: UIWindow) {
        let vc = MenuBuilder().build()
//        let nav = CommonNavigationController(rootViewController: vc)
//        window.rootViewController = nav
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }

    func keyWindow() -> UIWindow {
        guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            fatalError("No KeyWindow")
        }
        return keyWindow
    }
    
    func presentAlert(
        _ title: String?,
        _ message: String?,
        cancelActionTitle: String?,
        actionTitles: [String],
        style: UIAlertController.Style = .alert
    ) -> Observable<String> {
        return Observable.create { observer in
            let alertView = UIAlertController(title: title, message: message, preferredStyle: style)
            if let cancelActionTitle = cancelActionTitle {
                alertView.addAction(UIAlertAction(title: cancelActionTitle, style: .cancel) { _ in
                    observer.on(.next(cancelActionTitle))
                })
            }
            for actionTitle in actionTitles {
                alertView.addAction(UIAlertAction(title: actionTitle, style: .default) { _ in
                    observer.on(.next(actionTitle))
                })
            }
            self.topViewController().present(alertView, animated: true, completion: nil)

            return Disposables.create {
                alertView.dismiss(animated: false, completion: nil)
            }
        }
    }

    ///デフォルトのアラートダイアログを表示する(確認ボタンのみ)
    /// - Returns: 選択されたボタンのタイトルをObservable<String>で返す。
    func presentAlert(_ message: String = "", buttonTitle: String) -> Observable<String> {
        return self.presentAlert("", message, cancelActionTitle: nil, actionTitles: [buttonTitle], style: .alert)
    }

    ///エラーをデフォルトのアラートダイアログで表示する
    /// - Returns: 選択されたボタンのタイトルをObservable<AppErrorUserOption>で返す。
    func presentErrorAlert(_ errorType: AppErrorTypeProtocol?) -> Observable<AppErrorUserOption> {
        guard let errorType = errorType else {
            return Observable.just(.close)
        }

        let cancelTitle = errorType.cancelUserResponse?.rawValue

        let actionTitles = errorType.userResponses.map { $0.rawValue }

        return self.presentAlert("", errorType.message, cancelActionTitle: cancelTitle, actionTitles: actionTitles, style: .alert)
            .map({ AppErrorUserOption(rawValue: $0) ?? AppErrorUserOption.close })
    }
    
    ///  ローディング画面をtopViewControllerのchildとして表示
    /// - Parameters:
    ///     -  isStart: true(ローディング画面表示)、false(ローディング画面を非表示)
//    func showLoadingViewController(_ isStart: Bool) {
//        if isStart {
//            removeLoadingViewController()
//            loadingViewController = LoadingViewController()
//            topViewController().addChildViewController(loadingViewController!)
//            loadingViewController?.startAnimating()
//        } else {
//            removeLoadingViewController()
//        }
//    }
}

private extension DefaultWireframe {
    func rootViewController() -> UIViewController {
        guard let root = keyWindow().rootViewController else {
            fatalError("No RootViewControler")
        }
        return root
    }
    
    func topViewController() -> UIViewController {
        var topViewController = rootViewController()
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        if let navigationController = topViewController as? UINavigationController,
           let viewController = navigationController.children.last {
            topViewController = viewController
        }
        return topViewController
    }
}
