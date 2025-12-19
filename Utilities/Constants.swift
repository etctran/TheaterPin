//
//  Constants.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/25/25.
//

import Foundation

struct Constants {
    static let tmdbAPIKey = "7fc0aa750752200513d66e03b136a6c3"
    static let tmdbBaseURL = "https://api.themoviedb.org/3"
    static let tmdbImageBaseURL = "https://image.tmdb.org/t/p"
    
    struct ImageSizes {
        static let poster = "w500"
        static let backdrop = "w780"
        static let profile = "w185"
    }
    
    struct Endpoints {
        static let trending = "/trending/movie/day"
        static let popular = "/movie/popular"
        static let search = "/search/movie"
        static let movieDetails = "/movie"
        static let movieCredits = "/movie/{id}/credits"
        static let similarMovies = "/movie/{id}/similar"
    }
}