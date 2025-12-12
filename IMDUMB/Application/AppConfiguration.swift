//
//  AppConfiguration.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

enum AppEnvironment {
    case dev
    case prod
}

struct AppConfiguration {

    static let environment: AppEnvironment = {
        #if DEV
        return .dev
        #else
        return .prod
        #endif
    }()

    static var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    
    static let posterBaseURL = "https://image.tmdb.org/t/p/w185"

    static var imageBaseURL: String {
        return "https://image.tmdb.org/t/p/w500"
    }

    static var tmdbBearerToken: String {
        switch environment {
        case .dev:
            return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwN2JlZmYyY2EwYWM2NTQzNDQ1MDAxYTM2NTEwNjY4NiIsIm5iZiI6MTc2NTU0NDk3Ni44MTYsInN1YiI6IjY5M2MxNDEwODc4MjVmMjY3NzAxMzJiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.mTAQXoyWjWit5aP1kYq6u7_FWUJayGe_qmqucu2XXe8"
        case .prod:
            return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwN2JlZmYyY2EwYWM2NTQzNDQ1MDAxYTM2NTEwNjY4NiIsIm5iZiI6MTc2NTU0NDk3Ni44MTYsInN1YiI6IjY5M2MxNDEwODc4MjVmMjY3NzAxMzJiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.mTAQXoyWjWit5aP1kYq6u7_FWUJayGe_qmqucu2XXe8"
        }
    }

    // Ejemplo de feature toggle leído luego desde Firebase si quieres
    static var useMockRemoteDataStore: Bool = false
}
