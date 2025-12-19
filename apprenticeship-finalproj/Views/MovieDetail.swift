//
//  MovieDetailView.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import SwiftUI
import SwiftData
import WebKit

struct MovieDetailView: View {
    let movie: TMDBMovie
    @State var viewModel = MovieDetailViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    

    @Query var savedMovies: [MovieItem]
    
    var isMovieInLibrary: Bool {
        savedMovies.contains { $0.movieID == movie.id }
    }
    
    var isMovieWatched: Bool {
        savedMovies.first { $0.movieID == movie.id }?.isWatched ?? false
    }
    
    init(movie: TMDBMovie) {
        self.movie = movie
        self._savedMovies = Query(filter: #Predicate { movieItem in
            movieItem.movieID == movie.id
        })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: movie.backdropURL ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(16/9, contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 250)
                                .overlay {
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                }
                        }
                        

                        LinearGradient(
                            colors: [.clear, .black.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        HStack(alignment: .bottom, spacing: 16) {
                            AsyncImage(url: URL(string: movie.posterURL ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(2/3, contentMode: .fill)
                                    .frame(width: 100, height: 150)
                                    .clipped()
                                    .cornerRadius(12)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(12)
                                    .overlay {
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                    }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(movie.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(movie.ratingText)
                                        .foregroundColor(.white)
                                    
                                    Text("•")
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Text(movie.formattedReleaseDate)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .font(.caption)
                                
                                if let runtime = viewModel.movieDetails?.runtime, runtime > 0 {
                                    Text("\(runtime) min")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 12) {
                            Button(action: {
                                if !isMovieInLibrary {
                                    addMovieToLibrary(isWatched: false)
                                }
                            }) {
                                HStack {
                                    Image(systemName: isMovieInLibrary ? "checkmark" : "plus")
                                    Text(isMovieInLibrary ? "In Library" : "Add to Library")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(isMovieInLibrary ? AppTheme.textSecondary : AppTheme.primary)
                                .cornerRadius(12)
                            }
                            .disabled(isMovieInLibrary)
                            
                            Button(action: {
                                if isMovieInLibrary && !isMovieWatched {
                                    if let existingMovie = savedMovies.first {
                                        existingMovie.isWatched = true
                                        try? modelContext.save()
                                    }
                                } else if !isMovieInLibrary {
                                    addMovieToLibrary(isWatched: true)
                                }
                            }) {
                                HStack {
                                    Image(systemName: isMovieWatched ? "checkmark" : "eye")
                                    Text(isMovieWatched ? "Watched" : "Mark as Watched")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(isMovieWatched ? AppTheme.textSecondary : AppTheme.secondary)
                                .cornerRadius(12)
                            }
                            .disabled(isMovieWatched)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overview")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            Text(movie.overview)
                                .font(.body)
                                .padding(.horizontal)
                                .lineLimit(nil)
                        }
                        
                        if let genres = viewModel.movieDetails?.genres, !genres.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Genres")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(genres) { genre in
                                            Text(genre.name)
                                                .font(.caption)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.blue.opacity(0.2))
                                                .foregroundColor(.blue)
                                                .cornerRadius(16)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        if !viewModel.cast.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Cast")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(viewModel.cast) { castMember in
                                            CastMemberCard(castMember: castMember)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        if !viewModel.similarMovies.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Similar Movies")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(viewModel.similarMovies) { similarMovie in
                                            MovieCard(movie: similarMovie, width: 120)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.loadMovieDetails(movieID: movie.id)
            }
        }
    }
    
    func addMovieToLibrary(isWatched: Bool) {
        let movieItem = MovieItem(
            movieID: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            overview: movie.overview,
            releaseDate: movie.releaseDate,
            isWatched: isWatched
        )
        modelContext.insert(movieItem)
        try? modelContext.save()
    }
}

struct CastMemberCard: View {
    let castMember: TMDBCastMember
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: castMember.profileURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    }
            }
            
            VStack(spacing: 2) {
                Text(castMember.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text(castMember.character)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(width: 80)
        }
    }
}

#Preview {
    MovieDetailView(
        movie: TMDBMovie(
            id: 1,
            title: "Sample Movie",
            overview: "This is a sample movie overview that describes the plot and main story points of this incredible film.",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            genreIds: [],
            adult: false,
            originalLanguage: "en",
            originalTitle: "Sample Movie",
            popularity: 100.0,
            video: false,
            runtime: 120,
            genres: nil,
            status: nil,
            tagline: nil,
            budget: nil,
            revenue: nil,
            homepage: nil,
            imdbId: nil
        )
    )
}
