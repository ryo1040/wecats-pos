//
//  SettingsBuilder.swift
//  wecatspos
//
//  Created by matsumoto on 2026/05/04.
//

import UIKit

struct SettingsBuilder {
    func build() -> UIViewController {
        let viewController = SettingsViewController()
        let useCase = SettingsUseCase(settingsRepository: SettingsRepository())
        let wireframe = SettingsWireframe(viewController: viewController)
        let presenter = SettingsPresenter(wireframe: wireframe, useCase: useCase)

        viewController.inject(presenter: presenter)

        return viewController
    }
}
