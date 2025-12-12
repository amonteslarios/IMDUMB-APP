import Foundation

final class MovieRepositoryImpl: MovieRepository {

    private let remote: MovieRemoteDataStore
    private let local: MovieLocalDataStore

    // SOLID - DIP: depende de MovieRemoteDataStore y MovieLocalDataStore (protocolos).
    init(remote: MovieRemoteDataStore, local: MovieLocalDataStore) {
        self.remote = remote
        self.local = local
    }

    // MARK: - Categorías + películas

    func fetchCategoriesWithMovies(completion: @escaping (Result<[MovieCategory], Error>) -> Void) {
        remote.fetchGenres { [weak self] genresResult in
            guard let self = self else { return }

            switch genresResult {
            case .failure(let error):
                completion(.failure(error))

            case .success(let genres):
                self.buildCategories(from: genres, completion: completion)
            }
        }
    }

    private func buildCategories(
        from genres: [GenreDTO],
        completion: @escaping (Result<[MovieCategory], Error>) -> Void
    ) {
        var categories: [MovieCategory] = []
        let group = DispatchGroup()
        var firstError: Error?

        for genre in genres {
            group.enter()
            remote.fetchMovies(for: genre.id) { result in
                switch result {
                case .success(let moviesDTO):
                    let movies: [Movie] = moviesDTO.map { dto in
                        // Para la lista solo nos importa el poster y, opcionalmente,
                        // un backdrop como primera imagen del carrusel.
                        let imageURLs: [URL]
                        if let backdropPath = dto.backdrop_path,
                           let url = URL(string: AppConfiguration.imageBaseURL + backdropPath) {
                            imageURLs = [url]
                        } else {
                            imageURLs = []
                        }

                        return Movie(
                            id: dto.id,
                            title: dto.title,
                            rating: dto.vote_average,
                            overviewHTML: dto.overview,
                            posterPath: dto.poster_path,
                            imageURLs: imageURLs,
                            actors: []          // se cargan en el detalle
                        )
                    }

                    let category = MovieCategory(
                        id: genre.id,
                        name: genre.name,
                        movies: movies
                    )
                    categories.append(category)

                case .failure(let error):
                    if firstError == nil { firstError = error }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            if let error = firstError, categories.isEmpty {
                completion(.failure(error))
            } else {
                self.local.save(categories: categories)
                completion(.success(categories))
            }
        }
    }

    // MARK: - Detalle de película

    func fetchMovieDetail(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let group = DispatchGroup()

        var detailDTO: MovieDetailDTO?
        var credits: [CastDTO] = []
        var images: [ImageDTO] = []
        var firstError: Error?

        group.enter()
        remote.fetchMovieDetail(id: id) { result in
            switch result {
            case .success(let dto):
                detailDTO = dto
            case .failure(let error):
                firstError = error
            }
            group.leave()
        }

        group.enter()
        remote.fetchMovieCredits(id: id) { result in
            if case .success(let cast) = result {
                credits = cast
            }
            group.leave()
        }

        group.enter()
        remote.fetchMovieImages(id: id) { result in
            if case .success(let imgs) = result {
                images = imgs
            }
            group.leave()
        }

        group.notify(queue: .main) {
            if let error = firstError, detailDTO == nil {
                completion(.failure(error))
                return
            }

            guard let dto = detailDTO else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }

            let actors: [Actor] = credits.map {
                Actor(id: $0.id, name: $0.name)
            }

            let imageURLs: [URL] = images.compactMap {
                URL(string: AppConfiguration.imageBaseURL + $0.file_path)
            }

            let movie = Movie(
                id: dto.id,
                title: dto.title,
                rating: dto.vote_average,
                overviewHTML: dto.overview,
                posterPath: dto.poster_path,
                imageURLs: imageURLs,
                actors: actors
            )

            completion(.success(movie))
        }
    }
}
