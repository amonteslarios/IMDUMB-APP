//
//  MovieLocalDataStore.swift
//  IMDUMB
//
//  Created by Anthony Montes Larios on 12/12/25.
//

import Foundation

protocol MovieLocalDataStore {
    func save(categories: [MovieCategory])
    func getCategories() -> [MovieCategory]
}

final class MovieLocalDataStoreImpl: MovieLocalDataStore {

    private let key = "cached_categories"

    func save(categories: [MovieCategory]) {
        // Aquí podrías implementar cache real con Codable + UserDefaults/CoreData.
    }

    func getCategories() -> [MovieCategory] {
        []
    }
}
