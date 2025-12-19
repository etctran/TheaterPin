//
//  MovieCarousel.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import SwiftUI

struct MovieCarousel: View {
    let title: String
    let movies: [TMDBMovie]
    let cardWidth: CGFloat = 150
    let onMovieTap: (TMDBMovie) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(movies) { movie in
                        MovieCard(movie: movie, width: cardWidth)
                            .onTapGesture {
                                onMovieTap(movie)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MovieCarousel(
        title: "Trending Movies",
        movies: Array(repeating: TMDBMovie(
            id: 1,
            title: "Sample Movie",
            overview: "A great movie",
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
            runtime: nil,
            genres: nil,
            status: nil,
            tagline: nil,
            budget: nil,
            revenue: nil,
            homepage: nil,
            imdbId: nil
        ), count: 5),
        onMovieTap: { _ in }
    )
}
