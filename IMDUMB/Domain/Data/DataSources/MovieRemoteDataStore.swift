//
//  MovieRemoteDataStore.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation
import Alamofire

protocol MovieRemoteDataStore {
    func fetchGenres(completion: @escaping (Result<[GenreDTO], Error>) -> Void)
    func fetchMovies(for genreId: Int, completion: @escaping (Result<[MovieSummaryDTO], Error>) -> Void)
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetailDTO, Error>) -> Void)
    func fetchMovieCredits(id: Int, completion: @escaping (Result<[CastDTO], Error>) -> Void)
    func fetchMovieImages(id: Int, completion: @escaping (Result<[ImageDTO], Error>) -> Void)
}

final class MovieRemoteDataStoreImpl: MovieRemoteDataStore {

    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func fetchGenres(completion: @escaping (Result<[GenreDTO], Error>) -> Void) {
        request(TMDBAPI.genres) { (result: Result<GenresResponseDTO, Error>) in
            completion(result.map { $0.genres })
        }
    }

    func fetchMovies(for genreId: Int, completion: @escaping (Result<[MovieSummaryDTO], Error>) -> Void) {
        request(TMDBAPI.discoverByGenre(genreId: genreId)) { (result: Result<DiscoverMoviesResponseDTO, Error>) in
            completion(result.map { $0.results })
        }
    }

    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetailDTO, Error>) -> Void) {
        request(TMDBAPI.movieDetail(id: id), completion: completion)
    }

    func fetchMovieCredits(id: Int, completion: @escaping (Result<[CastDTO], Error>) -> Void) {
        request(TMDBAPI.movieCredits(id: id)) { (result: Result<MovieCreditsDTO, Error>) in
            completion(result.map { $0.cast })
        }
    }

    func fetchMovieImages(id: Int, completion: @escaping (Result<[ImageDTO], Error>) -> Void) {
        request(TMDBAPI.movieImages(id: id)) { (result: Result<MovieImagesDTO, Error>) in
            completion(result.map { $0.backdrops })
        }
    }

    // Helper genérico usando Alamofire
    private func request<T: Decodable>(
        _ endpoint: TMDBAPI,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        session.request(endpoint)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
