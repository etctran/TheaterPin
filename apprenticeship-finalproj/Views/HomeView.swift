//
//  HomeView.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import SwiftUI
import Observation

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    @State var selectedMovie: TMDBMovie?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    if viewModel.isLoading && viewModel.trendingMovies.isEmpty {
                        VStack {
                            ProgressView("Loading movies...")
                                .foregroundColor(AppTheme.primary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                    } else {
                        if !viewModel.trendingMovies.isEmpty {
                            VStack(spacing: 0) {
                                TabView {
                                    ForEach(Array(viewModel.trendingMovies.prefix(5))) { movie in
                                        FeaturedMovieCard(movie: movie) {
                                            selectedMovie = movie
                                        }
                                        .padding(.horizontal, 8)
                                    }
                                }
                                .tabViewStyle(.page(indexDisplayMode: .always))
                                .frame(height: 260)
                            }
                            .frame(height: 280) 
                        }
                        
                        if viewModel.trendingMovies.count > 5 {
                            MovieCarousel(
                                title: "Trending Now",
                                movies: Array(viewModel.trendingMovies.dropFirst(5)),
                                onMovieTap: { movie in
                                    selectedMovie = movie
                                }
                            )
                        }
                        
                        if !viewModel.popularMovies.isEmpty {
                            MovieCarousel(
                                title: "Popular Movies",
                                movies: viewModel.popularMovies,
                                onMovieTap: { movie in
                                    selectedMovie = movie
                                }
                            )
                        }
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        ErrorView(message: errorMessage) {
                            Task {
                                await viewModel.refreshContent()
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(AppTheme.background)
            .navigationTitle("Movies")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await viewModel.refreshContent()
            }
            .task {
                if viewModel.trendingMovies.isEmpty {
                    await viewModel.loadContent()
                }
            }
            .sheet(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }
}

struct FeaturedMovieCard: View {
    let movie: TMDBMovie
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottom) {
                if let backdropURL = movie.backdropURL {
                    AsyncImage(url: URL(string: backdropURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 220)
                                .clipped()
                        case .failure(_):
                            placeholderView
                        case .empty:
                            placeholderView
                                .overlay {
                                    ProgressView()
                                        .tint(.white)
                                }
                        @unknown default:
                            placeholderView
                        }
                    }
                } else {
                    placeholderView
                }
                
                LinearGradient(
                    colors: [.clear, .black.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .lineLimit(2)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(AppTheme.gold)
                                    .font(.caption)
                                
                                Text(movie.ratingText)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("•")
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text(movie.formattedReleaseDate)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding()
            }
            .frame(height: 220)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
    
    var placeholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 220)
            .overlay {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}


#Preview {
    HomeView()
}
