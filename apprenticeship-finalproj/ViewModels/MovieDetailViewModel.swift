//
//  MovieDetailViewModel.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
class MovieDetailViewModel {
    var movieDetails: TMDBMovie?
    var cast: [TMDBCastMember] = []
    var similarMovies: [TMDBMovie] = []
    var isLoading = false
    var errorMessage: String?
    
    private let tmdbService = TMDBService.shared
    
    func loadMovieDetails(movieID: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let details = tmdbService.fetchMovieDetails(id: movieID)
            async let credits = tmdbService.fetchMovieCredits(id: movieID)
            async let similar = tmdbService.fetchSimilarMovies(id: movieID)
            
            let (movieDetails, creditsResponse, similarMovies) = try await (details, credits, similar)
            
            self.movieDetails = movieDetails
            self.cast = Array(creditsResponse.cast.prefix(10))
            self.similarMovies = Array(similarMovies.prefix(10)) 
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error loading movie details: \(error)")
        }
        
        isLoading = false
    }
}
