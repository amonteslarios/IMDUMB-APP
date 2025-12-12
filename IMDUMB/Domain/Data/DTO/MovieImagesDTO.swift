//
//  MovieImagesDTO.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

struct MovieImagesDTO: Decodable {
    let backdrops: [ImageDTO]
}

struct ImageDTO: Decodable {
    let file_path: String
}
