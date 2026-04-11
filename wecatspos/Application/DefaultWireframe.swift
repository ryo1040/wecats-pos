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
        if #available(iOS 13.0, *) {
            let activeScenes = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }

            if let keyWindow = activeScenes
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) {
                return keyWindow
            }

            if let window = activeScenes
                .flatMap({ $0.windows })
                .first {
                return window
            }
        }

        fatalError("No KeyWindow")
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
    @available(iOS 13.0, *)
    func activeWindowScene() -> UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })
    }

    func rootViewController() -> UIViewController {
        if #available(iOS 13.0, *),
           let sceneRoot = activeWindowScene()?
            .windows
            .first(where: { $0.isKeyWindow })?
            .rootViewController {
            return sceneRoot
        }

        guard let root = keyWindow().rootViewController else {
            fatalError("No RootViewControler")
        }
        return root
    }
    
    func topViewController() -> UIViewController {
        visibleViewController(from: rootViewController())
    }

    func visibleViewController(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController {
            return visibleViewController(from: presented)
        }

        if let navigationController = viewController as? UINavigationController,
           let visible = navigationController.visibleViewController {
            return visibleViewController(from: visible)
        }

        if let tabBarController = viewController as? UITabBarController,
           let selected = tabBarController.selectedViewController {
            return visibleViewController(from: selected)
        }

        if let splitViewController = viewController as? UISplitViewController,
           let last = splitViewController.viewControllers.last {
            return visibleViewController(from: last)
        }

        return viewController
    }
}
