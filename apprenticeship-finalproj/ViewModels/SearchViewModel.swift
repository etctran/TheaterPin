//
//  SearchViewModel.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
class SearchViewModel {
    var searchText: String = ""
    var searchResults: [TMDBMovie] = []
    var isLoading = false
    var errorMessage: String?
    var hasSearched = false
    
    let tmdbService = TMDBService.shared
    
    func performSearch(query: String) async {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedQuery.count >= 2 else {  
            searchResults = []
            hasSearched = trimmedQuery.count > 0
            errorMessage = nil
            return
        }
        
        isLoading = true
        errorMessage = nil
        hasSearched = true
        
        do {
            let results = try await tmdbService.searchMovies(query: trimmedQuery)
            self.searchResults = results
        } catch {
            self.errorMessage = error.localizedDescription
            self.searchResults = []
        }
        
        isLoading = false
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
        hasSearched = false
        errorMessage = nil
    }
}
