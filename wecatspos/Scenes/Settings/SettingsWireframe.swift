//
//  SettingsWireframe.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import Foundation
import UIKit

protocol SettingsWireframeProtocol: BaseWireframeProtocol {
    func presentMenu()
    func presentViewController(viewController: UIViewController)
}

class SettingsWireframe: BaseWireframe, SettingsWireframeProtocol {

    weak private var viewController: SettingsViewController!

    init (viewController: SettingsViewController) {
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
