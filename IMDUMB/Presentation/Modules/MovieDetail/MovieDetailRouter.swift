//
//  MovieDetailRouter.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import UIKit

enum MovieDetailRouter {

    static func build(movieId: Int) -> UIViewController {
        let vc = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        let useCase = DependencyContainer.shared.makeFetchMovieDetailUseCase()
        let presenter = MovieDetailPresenter(
            view: vc,
            fetchMovieDetailUseCase: useCase,
            movieId: movieId
        )
        vc.presenter = presenter
        return vc
    }

    static func presentRecommend(from view: UIViewController, movie: Movie) {
        let vc = RecommendModalViewController(nibName: "RecommendModalViewController", bundle: nil)
        let presenter = RecommendModalPresenter(view: vc, movie: movie)
        vc.presenter = presenter
        vc.modalPresentationStyle = .pageSheet
        view.present(vc, animated: true)
    }
}
