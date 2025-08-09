//
//  TotalWireframe.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/09.
//

import Foundation
import UIKit

protocol TotalWireframeProtocol: BaseWireframeProtocol {
    func presentMenu()
    func presentViewController(viewController: UIViewController)
}

class TotalWireframe: BaseWireframe, TotalWireframeProtocol {

    weak private var viewController: TotalViewController!

    init (viewController: TotalViewController) {
        self.viewController = viewController
    }
    
    func presentMenu() {
        let vc = MenuBuilder().build()
        presentViewController(viewController: vc)
    }
    
    // 指定したviewController
    func presentViewController(viewController: UIViewController) {
        let window = DefaultWireframe.shared.keyWindow()
        window.rootViewController = viewController
    }
}
