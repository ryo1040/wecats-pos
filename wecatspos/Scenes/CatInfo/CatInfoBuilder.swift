//
//  CatInfoBuilder.swift
//  wecatspos
//
//  Created by matsumoto on 2025/04/29.
//

import UIKit

struct CatInfoBuilder {
    func build() -> UIViewController {
        let viewController = CatInfoViewController()
        let useCase = CatInfoUseCase(catInfoRepository: CatInfoRepository())
        let wireframe = CatInfoWireframe(viewController: viewController)
        let presenter = CatInfoPresenter(useCase: useCase, wireframe: wireframe)

        viewController.inject(presenter: presenter)

        return viewController
    }
}
