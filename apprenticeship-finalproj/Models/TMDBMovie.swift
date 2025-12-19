//
//  TMDBMovie.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/25/25.
//

import Foundation

struct TMDBMovie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let genreIds: [Int]?
    let adult: Bool
    let originalLanguage: String
    let originalTitle: String
    let popularity: Double
    let video: Bool
    
    let runtime: Int?
    let genres: [TMDBGenre]?
    let status: String?
    let tagline: String?
    let budget: Int?
    let revenue: Int?
    let homepage: String?
    let imdbId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, adult, video, popularity, homepage, tagline, status, runtime, budget, revenue, genres
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case imdbId = "imdb_id"
    }
    
    var posterURL: String? {
        guard let posterPath = posterPath else { return nil }
        return "\(Constants.tmdbImageBaseURL)/\(Constants.ImageSizes.poster)\(posterPath)"
    }
    
    var backdropURL: String? {
        guard let backdropPath = backdropPath else { return nil }
        return "\(Constants.tmdbImageBaseURL)/\(Constants.ImageSizes.backdrop)\(backdropPath)"
    }
    
    var formattedReleaseDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: releaseDate) {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return releaseDate
    }
    
    var ratingText: String {
        return String(format: "%.1f", voteAverage)
    }
}

struct TMDBMovieResponse: Codable {
    let page: Int
    let results: [TMDBMovie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
