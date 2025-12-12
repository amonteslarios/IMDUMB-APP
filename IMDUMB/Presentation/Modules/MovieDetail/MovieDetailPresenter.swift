//
//  MoviewDetailPresenter.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

final class MovieDetailPresenter {

    private weak var view: MovieDetailView?
    private let fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol
    private let movieId: Int

    init(
        view: MovieDetailView,
        fetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol,
        movieId: Int
    ) {
        self.view = view
        self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
        self.movieId = movieId
    }

    func onViewDidLoad() {
        view?.showLoading(true)
        fetchMovieDetailUseCase.execute(movieId: movieId) { [weak self] result in
            guard let self = self else { return }
            self.view?.showLoading(false)
            switch result {
            case .success(let movie):
                self.view?.showMovie(movie)
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
}
