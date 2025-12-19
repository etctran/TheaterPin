//
//  LibraryViewModel.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/24/25.
//

import Foundation
import SwiftUI
import SwiftData
import Observation

@MainActor
@Observable
class LibraryViewModel {
    var watchedMovies: [MovieItem] = []
    var wantToWatchMovies: [MovieItem] = []
    var errorMessage: String?
    
    var modelContext: ModelContext?
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadMovies()
    }
    
    func loadMovies() {
        guard let modelContext = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<MovieItem>()
            let allMovies = try modelContext.fetch(descriptor)
            
            watchedMovies = allMovies.filter { $0.isWatched }
            wantToWatchMovies = allMovies.filter { !$0.isWatched }
            
        } catch {
            errorMessage = "Failed to load movies: \(error.localizedDescription)"
        }
    }
    
    func addMovieToLibrary(_ tmdbMovie: TMDBMovie, isWatched: Bool) {
        guard let modelContext = modelContext else { return }
        
        let allMovies = watchedMovies + wantToWatchMovies
        let existingMovie = allMovies.first { $0.movieID == tmdbMovie.id }
        
        do {
            
            if let existingMovie = existingMovie {
                existingMovie.isWatched = isWatched
            } else {
                let movieItem = MovieItem(
                    movieID: tmdbMovie.id,
                    title: tmdbMovie.title,
                    posterPath: tmdbMovie.posterPath,
                    backdropPath: tmdbMovie.backdropPath,
                    overview: tmdbMovie.overview,
                    releaseDate: tmdbMovie.releaseDate,
                    isWatched: isWatched
                )
                modelContext.insert(movieItem)
            }
            
            try modelContext.save()
            loadMovies()
            
        } catch {
            errorMessage = "Failed to save movie: \(error.localizedDescription)"
        }
    }
    
    func removeMovieFromLibrary(_ movieItem: MovieItem) {
        guard let modelContext = modelContext else { return }
        
        modelContext.delete(movieItem)
        
        do {
            try modelContext.save()
            loadMovies() 
        } catch {
            errorMessage = "Failed to remove movie: \(error.localizedDescription)"
        }
    }
    
    func updateMovieRating(_ movieItem: MovieItem, rating: Int) {
        guard let modelContext = modelContext else { return }
        
        movieItem.userRating = rating
        
        do {
            try modelContext.save()
            loadMovies()
        } catch {
            errorMessage = "Failed to update rating: \(error.localizedDescription)"
        }
    }
    
    func updateMovieNotes(_ movieItem: MovieItem, notes: String) {
        guard let modelContext = modelContext else { return }
        
        movieItem.userNotes = notes.isEmpty ? nil : notes
        
        do {
            try modelContext.save()
            loadMovies() 
        } catch {
            errorMessage = "Failed to update notes: \(error.localizedDescription)"
        }
    }
    
    func isMovieInLibrary(_ tmdbMovie: TMDBMovie) -> Bool {
        return watchedMovies.contains { $0.movieID == tmdbMovie.id } ||
               wantToWatchMovies.contains { $0.movieID == tmdbMovie.id }
    }
    
    func isMovieWatched(_ tmdbMovie: TMDBMovie) -> Bool {
        return watchedMovies.contains { $0.movieID == tmdbMovie.id }
    }
}
