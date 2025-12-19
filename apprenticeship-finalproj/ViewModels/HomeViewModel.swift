//
//  HomeViewModel.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
class HomeViewModel {
    var trendingMovies: [TMDBMovie] = []
    var popularMovies: [TMDBMovie] = []
    var isLoading = false
    var errorMessage: String?
    
    let tmdbService = TMDBService.shared
    
    func loadContent() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let trending = tmdbService.fetchTrendingMovies()
            async let popular = tmdbService.fetchPopularMovies()
            
            let (trendingResults, popularResults) = try await (trending, popular)
            
            self.trendingMovies = trendingResults
            self.popularMovies = popularResults
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error loading home content: \(error)")
        }
        
        isLoading = false
    }
    
    func refreshContent() async {
        await loadContent()
    }
}
