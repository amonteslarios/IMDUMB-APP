//
//  CategoriesRouter.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

enum CategoriesRouter {

    static func build() -> UIViewController {
        let vc = CategoriesViewController(nibName: "CategoriesViewController", bundle: nil)
        let useCase = DependencyContainer.shared.makeFetchCategoriesUseCase()
        let presenter = CategoriesPresenter(view: vc, fetchCategoriesUseCase: useCase)
        vc.presenter = presenter
        return vc
    }

    static func navigateToMovieDetail(from view: UIViewController, movieId: Int) {
        let detailVC = MovieDetailRouter.build(movieId: movieId)
        view.navigationController?.pushViewController(detailVC, animated: true)
    }
}
