//
//  FetchCategoriesUseCase.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

protocol FetchCategoriesUseCaseProtocol {
    func execute(completion: @escaping (Result<[MovieCategory], Error>) -> Void)
}

final class FetchCategoriesUseCase: FetchCategoriesUseCaseProtocol {

    private let repository: MovieRepository

    // SOLID - DIP: el caso de uso depende de la abstracción MovieRepository (protocolo),
    // no de una implementación concreta.
    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[MovieCategory], Error>) -> Void) {
        repository.fetchCategoriesWithMovies(completion: completion)
    }
}
