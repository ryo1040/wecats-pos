//
//  MenuWireframe.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//

import Foundation
import UIKit

protocol MenuWireframeProtocol: BaseWireframeProtocol {
    func presentCatInfo()
    func presentOpen()
    func presentTotal()
    func presentClose()
    func presentViewController(viewController: UIViewController)
}

class MenuWireframe: BaseWireframe, MenuWireframeProtocol {

    weak private var viewController: MenuViewController!

    init (viewController: MenuViewController) {
        self.viewController = viewController
    }
    
    func presentCatInfo() {
        let vc = CatInfoBuilder().build()
//        self.viewController.navigationController?.pushViewController(vc, animated: true)
        presentViewController(viewController: vc)
    }
    
    func presentOpen() {
        let vc = OpenBuilder().build()
//        self.viewController.navigationController?.pushViewController(vc, animated: true)
        presentViewController(viewController: vc)
    }
    
    func presentTotal() {
        let vc = TotalBuilder().build()
//        self.viewController.navigationController?.pushViewController(vc, animated: true)
        presentViewController(viewController: vc)
    }
    
    func presentClose() {
        let vc = CloseBuilder().build()
        presentViewController(viewController: vc)
    }
    
    // 指定したviewController
    func presentViewController(viewController: UIViewController) {
        let window = DefaultWireframe.shared.keyWindow()
        window.rootViewController = viewController
    }
}
