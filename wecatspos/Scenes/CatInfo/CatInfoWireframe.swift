//
//  CatInfoWireframe.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/29.
//

import Foundation
import UIKit

protocol CatInfoWireframeProtocol: BaseWireframeProtocol {
    func presentMenu()
    func presentViewController(viewController: UIViewController)
}

class CatInfoWireframe: BaseWireframe, CatInfoWireframeProtocol {

    weak private var viewController: CatInfoViewController!

    init (viewController: CatInfoViewController) {
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
