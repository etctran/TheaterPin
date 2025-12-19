//
//  MovieCard.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import SwiftUI

struct MovieCard: View {
    let movie: TMDBMovie
    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: movie.posterURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fill)
                    .frame(width: width, height: width * 1.5)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: width, height: width * 1.5)
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
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    
                    Text(movie.ratingText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(movie.formattedReleaseDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: width)
        }
    }
}

#Preview {
    MovieCard(
        movie: TMDBMovie(
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
        ),
        width: 150
    )
    .padding()
}
