//
//  MovieMockDataStore.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

final class MovieMockDataStore: MovieRemoteDataStore {

    func fetchGenres(completion: @escaping (Result<[GenreDTO], Error>) -> Void) {
        let genres = [
            GenreDTO(id: 28, name: "Action"),
            GenreDTO(id: 35, name: "Comedy")
        ]
        completion(.success(genres))
    }

    func fetchMovies(for genreId: Int, completion: @escaping (Result<[MovieSummaryDTO], Error>) -> Void) {
        let movies = [
            MovieSummaryDTO(
                id: 1,
                title: "Mock Movie",
                vote_average: 8.2,
                overview: "<p>Mock overview</p>",
                poster_path: nil,
                backdrop_path: nil
            )
        ]
        completion(.success(movies))
    }

    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetailDTO, Error>) -> Void) {
        completion(.success(MovieDetailDTO(
            id: id,
            title: "Mock Detail",
            vote_average: 8.5,
            overview: "<p>Mock detail overview</p>", poster_path: "Mock Poster"
        )))
    }

    func fetchMovieCredits(id: Int, completion: @escaping (Result<[CastDTO], Error>) -> Void) {
        completion(.success([CastDTO(id: 1, name: "Mock Actor")]))
    }

    func fetchMovieImages(id: Int, completion: @escaping (Result<[ImageDTO], Error>) -> Void) {
        completion(.success([]))
    }
}
