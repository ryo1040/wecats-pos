//
//  MenuBuilder.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/28.
//

import UIKit

struct MenuBuilder {
    func build() -> UIViewController {
        let viewController = MenuViewController()
//        let useCase = MenuUseCase(MenuRepository: MenuRepository(), userDefaultRepository: UserDefaultRepository(), commonRepository: CommonRepository())
        let wireframe = MenuWireframe(viewController: viewController)
//        let imageLoader = ImageLoader()
        let presenter = MenuPresenter(wireframe: wireframe)

        viewController.inject(presenter: presenter)

        return viewController
    }
}
