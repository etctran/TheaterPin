//
//  MovieItem.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/17/25.
//

import Foundation
import SwiftData

@Model
final class MovieItem {
    var id: UUID
    var movieID: Int
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var overview: String
    var releaseDate: String
    var isWatched: Bool
    var dateAdded: Date
    var userRating: Int?
    var userNotes: String?
    
    init(
        movieID: Int,
        title: String,
        posterPath: String? = nil,
        backdropPath: String? = nil,
        overview: String,
        releaseDate: String,
        isWatched: Bool = false
    ) {
        self.id = UUID()
        self.movieID = movieID
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.isWatched = isWatched
        self.dateAdded = Date()
        self.userRating = nil
        self.userNotes = nil
    }
    
    var posterURL: String? {
        guard let posterPath = posterPath else { return nil }
        return "\(Constants.tmdbImageBaseURL)/\(Constants.ImageSizes.poster)\(posterPath)"
    }
    
    var backdropURL: String? {
        guard let backdropPath = backdropPath else { return nil }
        return "\(Constants.tmdbImageBaseURL)/\(Constants.ImageSizes.backdrop)\(backdropPath)"
    }
}
