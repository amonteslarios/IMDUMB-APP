//
//  DependencyContainer.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

final class DependencyContainer {

    static let shared = DependencyContainer()
    private init() {}

    // MARK: - Data Layer

    private lazy var remoteDataStore: MovieRemoteDataStore = {
        if AppConfiguration.useMockRemoteDataStore {
            return MovieMockDataStore()
        } else {
            // Usa Alamofire.Session por dentro
            return MovieRemoteDataStoreImpl()
        }
    }()

    private lazy var localDataStore: MovieLocalDataStore = MovieLocalDataStoreImpl()

    private lazy var movieRepository: MovieRepository = MovieRepositoryImpl(
        remote: remoteDataStore,
        local: localDataStore
    )

    // MARK: - UseCases

    func makeFetchCategoriesUseCase() -> FetchCategoriesUseCaseProtocol {
        FetchCategoriesUseCase(repository: movieRepository)
    }

    func makeFetchMovieDetailUseCase() -> FetchMovieDetailUseCaseProtocol {
        FetchMovieDetailUseCase(repository: movieRepository)
    }

    // MARK: - Firebase

    func makeRemoteConfigService() -> RemoteConfigServiceProtocol {
        FirebaseRemoteConfigService()
    }
}
