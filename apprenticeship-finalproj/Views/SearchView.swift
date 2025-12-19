//
//  SearchView.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import SwiftUI
import Observation

struct SearchView: View {
    @State private var viewModel = SearchViewModel()
    @State private var selectedMovie: TMDBMovie?
    @State private var debounceTask: Task<Void, Never>?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .onChange(of: viewModel.searchText) { _, newValue in
                        debounceTask?.cancel()
                        
                        debounceTask = Task {
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            if !Task.isCancelled {
                                await viewModel.performSearch(query: newValue)
                            }
                        }
                    }
                
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Searching movies...")
                        Spacer()
                    }
                } else if !viewModel.hasSearched {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        VStack(spacing: 8) {
                            Text("Search for Movies")
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Text("Discover your next favorite film")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .padding()
                } else if viewModel.searchResults.isEmpty && viewModel.errorMessage == nil {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "film.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        VStack(spacing: 8) {
                            Text("No movies found")
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            Text("Try adjusting your search terms")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Spacer()
                        ErrorView(message: errorMessage) {
                            Task {
                                await viewModel.performSearch(query: viewModel.searchText)
                            }
                        }
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.searchResults) { movie in
                                SearchMovieCard(movie: movie) {
                                    selectedMovie = movie
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                    }
                }
            }
            .background(AppTheme.background)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedMovie) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.textSecondary)
            
            TextField("Search movies...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button("Clear") {
                    text = ""
                }
                .foregroundColor(AppTheme.primary)
                .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppTheme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppTheme.textSecondary.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(10)
    }
}

struct SearchMovieCard: View {
    let movie: TMDBMovie
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: URL(string: movie.posterURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                        .frame(height: 240)
                        .clipped()
                        .cornerRadius(12)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 240)
                        .cornerRadius(12)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 44, alignment: .top)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppTheme.gold)
                            .font(.caption)
                        
                        Text(movie.ratingText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(String(movie.releaseDate.prefix(4)))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SearchView()
}
