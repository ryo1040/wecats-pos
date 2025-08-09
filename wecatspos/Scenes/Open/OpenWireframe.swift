//
//  OpenWireframe.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/03.
//

import Foundation
import UIKit

protocol OpenWireframeProtocol: BaseWireframeProtocol {
    func presentMenu()
    func presentViewController(viewController: UIViewController)
}

class OpenWireframe: BaseWireframe, OpenWireframeProtocol {

    weak private var viewController: OpenViewController!

    init (viewController: OpenViewController) {
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
