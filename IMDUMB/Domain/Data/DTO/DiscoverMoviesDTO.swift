//
//  DiscoverMoviesDTO.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

struct DiscoverMoviesResponseDTO: Decodable {
    let results: [MovieSummaryDTO]
}

struct MovieSummaryDTO: Decodable {
    let id: Int
    let title: String
    let vote_average: Double
    let overview: String
    let poster_path: String?
    let backdrop_path: String?
}
