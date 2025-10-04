//
//  CloseBuilder.swift
//  wecatspos
//
//  Created by matsumoto on 2025/08/19.
//

import UIKit

struct CloseBuilder {
    func build() -> UIViewController {
        let viewController = CloseViewController()
        let useCase = CloseUseCase(closeRepository: CloseRepository())
        let wireframe = CloseWireframe(viewController: viewController)
        let presenter = ClosePresenter(wireframe: wireframe, useCase: useCase)

        viewController.inject(presenter: presenter)

        return viewController
    }
}
