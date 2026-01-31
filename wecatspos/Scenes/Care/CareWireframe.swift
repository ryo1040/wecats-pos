//
//  CareWireframe.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import Foundation
import UIKit

protocol CareWireframeProtocol: BaseWireframeProtocol {
    func presentMenu()
    func presentViewController(viewController: UIViewController)
}

class CareWireframe: BaseWireframe, CareWireframeProtocol {

    weak private var viewController: CareViewController!

    init (viewController: CareViewController) {
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

