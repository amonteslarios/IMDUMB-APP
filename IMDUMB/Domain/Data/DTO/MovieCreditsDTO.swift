//
//  MovieCreditsDTO.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

struct MovieCreditsDTO: Decodable {
    let cast: [CastDTO]
}

struct CastDTO: Decodable {
    let id: Int
    let name: String
}
