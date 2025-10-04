//
//  CloseWireframe.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/19.
//

import Foundation
import UIKit

protocol CloseWireframeProtocol: BaseWireframeProtocol {
    func presentMenu()
    func presentViewController(viewController: UIViewController)
}

class CloseWireframe: BaseWireframe, CloseWireframeProtocol {

    weak private var viewController: CloseViewController!

    init (viewController: CloseViewController) {
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
