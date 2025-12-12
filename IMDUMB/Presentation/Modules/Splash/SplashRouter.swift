//
//  SplashRouter.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

enum SplashRouter {

    static func build() -> UIViewController {
        let vc = SplashViewController(nibName: "SplashViewController", bundle: nil)
        let configService = DependencyContainer.shared.makeRemoteConfigService()
        let presenter = SplashPresenter(view: vc, configService: configService)
        vc.presenter = presenter
        return vc
    }

    static func navigateToCategories(from view: SplashView) {
        guard let vc = view as? UIViewController else { return }
        let categoriesVC = CategoriesRouter.build()
        vc.navigationController?.setViewControllers([categoriesVC], animated: true)
    }
}
