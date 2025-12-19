//
//  LibraryView.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/25/25.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(\.modelContext) var modelContext
    @State var selectedSegment = 0
    @State var selectedMovieItem: MovieItem?
    
    @Query(filter: #Predicate<MovieItem> { movie in
        movie.isWatched == true 
    }) var watchedMovies: [MovieItem]
    
    @Query(filter: #Predicate<MovieItem> { movie in 
        movie.isWatched == false 
    }) var wantToWatchMovies: [MovieItem]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Library", selection: $selectedSegment) {
                    Text("Watched").tag(0)
                    Text("Want to Watch").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(AppTheme.surface)
                .padding()
                
                if selectedSegment == 0 {
                    if watchedMovies.isEmpty {
                        EmptyLibraryView(
                            title: "No Watched Movies",
                            subtitle: "Movies you mark as watched will appear here",
                            systemImage: "checkmark.circle"
                        )
                    } else {
                        List {
                            ForEach(watchedMovies) { movieItem in
                                LibraryMovieRow(movieItem: movieItem) {
                                    selectedMovieItem = movieItem
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    modelContext.delete(watchedMovies[index])
                                }
                            }
                        }
                    }
                } else {
                    if wantToWatchMovies.isEmpty {
                        EmptyLibraryView(
                            title: "No Movies in Watchlist",
                            subtitle: "Movies you want to watch will appear here",
                            systemImage: "bookmark.circle"
                        )
                    } else {
                        List {
                            ForEach(wantToWatchMovies) { movieItem in
                                LibraryMovieRow(movieItem: movieItem) {
                                    selectedMovieItem = movieItem
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    modelContext.delete(wantToWatchMovies[index])
                                }
                            }
                        }
                    }
                }
            }
            .background(AppTheme.background)
            .navigationTitle("My Library")
            .sheet(item: $selectedMovieItem) { movieItem in
                LibraryMovieDetailView(movieItem: movieItem)
            }
        }
    }
}

struct LibraryMovieRow: View {
    let movieItem: MovieItem
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: movieItem.posterURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fill)
                    .frame(width: 60, height: 90)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movieItem.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(movieItem.overview)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    if let userRating = movieItem.userRating {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(AppTheme.gold)
                                .font(.caption2)
                            Text("\(userRating)/10")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Text(String(movieItem.releaseDate.prefix(4)))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                if movieItem.userNotes?.isEmpty == false {
                    HStack {
                        Image(systemName: "note.text")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text("Has notes")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

struct EmptyLibraryView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct LibraryMovieDetailView: View {
    let movieItem: MovieItem
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var userRating: Int = 0
    @State var userNotes: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top, spacing: 16) {
                        AsyncImage(url: URL(string: movieItem.posterURL ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(2/3, contentMode: .fill)
                                .frame(width: 120, height: 180)
                                .clipped()
                                .cornerRadius(12)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 120, height: 180)
                                .cornerRadius(12)
                                .overlay {
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movieItem.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(movieItem.overview)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(6)
                            
                            Text("Added: \(movieItem.dateAdded.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Rating")
                            .font(.headline)
                        
                        HStack {
                            ForEach(1...10, id: \.self) { rating in
                                Button(action: {
                                    userRating = rating
                                    movieItem.userRating = rating
                                    try? modelContext.save()
                                }) {
                                    Image(systemName: rating <= userRating ? "star.fill" : "star")
                                        .font(.title2)
                                        .foregroundColor(rating <= userRating ? AppTheme.gold : .gray)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Notes")
                            .font(.headline)
                        
                        TextEditor(text: $userNotes)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: userNotes) { _, newValue in
                                movieItem.userNotes = newValue.isEmpty ? nil : newValue
                                try? modelContext.save()
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Status")
                            .font(.headline)
                        
                        Button {
                            movieItem.isWatched.toggle()
                            try? modelContext.save()
                        } label: {
                            HStack {
                                Image(systemName: movieItem.isWatched ? "checkmark.circle.fill" : "bookmark.circle.fill")
                                Text(movieItem.isWatched ? "Mark as Want to Watch" : "Mark as Watched")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(movieItem.isWatched ? Color.blue : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(movieItem.isWatched ? "Watched Movie" : "Want to Watch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                userRating = movieItem.userRating ?? 0
                userNotes = movieItem.userNotes ?? ""
            }
        }
    }
}

#Preview {
    LibraryView()
}
