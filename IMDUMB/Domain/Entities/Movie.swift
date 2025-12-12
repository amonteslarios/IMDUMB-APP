import Foundation

struct Movie {
    let id: Int
    let title: String
    let rating: Double
    let overviewHTML: String
    let posterPath: String?
    let imageURLs: [URL]
    let actors: [Actor]

    /// URL para el poster en las listas (categorías)
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: AppConfiguration.posterBaseURL + posterPath)
    }
}
