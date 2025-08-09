//
//  TotalBuilder.swift
//  wecatspos
//
//  Created by matsumoto on 2025/05/09.
//

import UIKit

struct TotalBuilder {
    func build() -> UIViewController {
        let viewController = TotalViewController()
        let useCase = TotalUseCase(totalRepository: TotalRepository())
        let wireframe = TotalWireframe(viewController: viewController)
//        let imageLoader = ImageLoader()
        let presenter = TotalPresenter(wireframe: wireframe, useCase: useCase)

        viewController.inject(presenter: presenter)

        return viewController
    }
}
