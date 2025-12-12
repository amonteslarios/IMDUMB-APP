//
//  CategoriesPresenter.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

final class CategoriesPresenter {

    private weak var view: CategoriesView?
    private let fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol

    // SOLID - ISP: la vista solo conoce el protocolo CategoriesView con lo mínimo necesario.
    init(view: CategoriesView, fetchCategoriesUseCase: FetchCategoriesUseCaseProtocol) {
        self.view = view
        self.fetchCategoriesUseCase = fetchCategoriesUseCase
    }

    func onViewDidLoad() {
        view?.showLoading(true)
        fetchCategoriesUseCase.execute { [weak self] result in
            guard let self = self else { return }
            self.view?.showLoading(false)
            switch result {
            case .success(let categories):
                self.view?.showCategories(categories)
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
}
