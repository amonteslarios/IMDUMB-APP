//
//  MovieRepository.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

protocol MovieRepository {
    func fetchCategoriesWithMovies(completion: @escaping (Result<[MovieCategory], Error>) -> Void)
    func fetchMovieDetail(id: Int, completion: @escaping (Result<Movie, Error>) -> Void)
}
