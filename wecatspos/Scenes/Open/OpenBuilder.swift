//
//  OpenBuilder.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/03.
//

import UIKit

struct OpenBuilder {
    func build() -> UIViewController {
        let viewController = OpenViewController()
        let useCase = OpenUseCase(openRepository: OpenRepository())
        let wireframe = OpenWireframe(viewController: viewController)
//        let imageLoader = ImageLoader()
        let presenter = OpenPresenter(wireframe: wireframe, useCase: useCase)

        viewController.inject(presenter: presenter)

        return viewController
    }
}
