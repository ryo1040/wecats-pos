//
//  CareBuilder.swift
//  wecatspos
//
//  Created by matsumoto on 2025/10/25.
//

import UIKit

struct CareBuilder {
    func build() -> UIViewController {
        let viewController = CareViewController()
        let useCase = CareUseCase(careRepository: CareRepository())
        let wireframe = CareWireframe(viewController: viewController)
        let presenter = CarePresenter(wireframe: wireframe, useCase: useCase)

        viewController.inject(presenter: presenter)

        return viewController
    }
}
