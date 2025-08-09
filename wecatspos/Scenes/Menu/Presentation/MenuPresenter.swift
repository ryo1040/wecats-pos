//
//  MenuPresenter.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//

import Foundation
import UIKit

protocol MenuPresenterProtocol: AnyObject {
    func didTapCatInfoButton()
    func didTapOpenButton()
    func didTapTotalButton()
}

final class MenuPresenter: MenuPresenterProtocol {
    
    var viewController = MenuViewController()
    
    private let wireframe: MenuWireframeProtocol!
    
    init(wireframe: MenuWireframeProtocol) {
        self.wireframe = wireframe
    }
    
    func didTapCatInfoButton() {
        wireframe.presentCatInfo()
    }
    
    func didTapOpenButton() {
        wireframe.presentOpen()
    }
    
    func didTapTotalButton() {
        wireframe.presentTotal()
    }
}
