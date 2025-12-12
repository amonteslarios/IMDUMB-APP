//
//  TMDBAPI.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation
import Alamofire

enum TMDBAPI: URLRequestConvertible {
    case genres
    case discoverByGenre(genreId: Int)
    case movieDetail(id: Int)
    case movieCredits(id: Int)
    case movieImages(id: Int)

    var baseURL: URL { URL(string: AppConfiguration.baseURL)! }
    var method: HTTPMethod { .get }

    var path: String {
        switch self {
        case .genres:
            return "/genre/movie/list"
        case .discoverByGenre:
            return "/discover/movie"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .movieCredits(let id):
            return "/movie/\(id)/credits"
        case .movieImages(let id):
            return "/movie/\(id)/images"
        }
    }

    var parameters: Parameters? {
        switch self {
        case .discoverByGenre(let genreId):
            return [
                "with_genres": "\(genreId)",
                "sort_by": "popularity.desc"
            ]
        default:
            return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.method = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(AppConfiguration.tmdbBearerToken)", forHTTPHeaderField: "Authorization")

        if let params = parameters {
            return try URLEncoding.default.encode(request, with: params)
        } else {
            return request
        }
    }
}
