//
//  RecommendModalPresenter.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

final class RecommendModalPresenter {

    private weak var view: RecommendModalView?
    private let movie: Movie

    init(view: RecommendModalView, movie: Movie) {
        self.view = view
        self.movie = movie
    }

    func onViewDidLoad() {
        view?.showMovie(title: movie.title, detail: movie.overviewHTML)
    }

    func confirmRecommendation(comment: String?) {        
        view?.closeWithSuccess()
    }
}
