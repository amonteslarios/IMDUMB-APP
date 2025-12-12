//
//  FetchMovieDetailUseCase.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

protocol FetchMovieDetailUseCaseProtocol {
    func execute(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void)
}

final class FetchMovieDetailUseCase: FetchMovieDetailUseCaseProtocol {

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        repository.fetchMovieDetail(id: movieId, completion: completion)
    }
}
