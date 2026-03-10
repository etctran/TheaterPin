# TheaterPin

TheaterPin is a comprehensive iOS application designed for movie enthusiasts to discover trending films and find nearby movie theaters. Built with **SwiftUI**, **SwiftData**, and the **Observation** framework, the app provides a seamless experience for browsing movie details and locating cinemas using MapKit.

## Features

* **Movie Discovery**: Browse trending and popular movies fetched directly from The Movie Database (TMDB).
* **Theater Locator**: Use GPS to find and navigate to the nearest movie theaters, with results sorted by distance.
* **City Search**: Search for movie theaters in specific cities using natural language queries.
* **Detailed Insights**: Access in-depth information for each film, including cast lists and similar movie recommendations.
* **Personal Library**: Save favorite movies to a local library using SwiftData for offline access and persistence.
* **Advanced Search**: Quickly find specific films within the extensive TMDB database.

## Technical Architecture

* **UI Framework**: Built entirely with **SwiftUI** for a modern, responsive user interface.
* **State Management**: Utilizes the modern **Observation** framework (`@Observable`) and `@MainActor` to ensure smooth UI updates and thread safety.
* **Networking**: Implements a robust networking layer using **URLSession** and **async/await** to interact with the TMDB API.
* **Local Persistence**: Employs **SwiftData** to manage and store user-saved movie items.
* **Location Services**: Integrates **CoreLocation** and **MapKit** for real-time location tracking and theater searching.

## Configuration

The app requires a TMDB API key to function. The API configuration is managed in the `Constants.swift` file:


## Project Structure

* **App**: Contains the main entry point and global `ModelContainer` setup for SwiftData.
* **Views**: SwiftUI views including `HomeView`, `TheaterMapView`, and `MovieDetail`.
* **ViewModels**: Logic handling for various screens, such as `HomeViewModel`, `MapViewModel`, and `SearchViewModel`.
* **Networking**: Services for API interaction (`TMDBService`) and location-based theater searches (`TheaterService`).
* **Models**: Data structures for `MovieItem`, `Theater`, and `TMDBMovie`.
* **Utilities**: App-wide constants and theme definitions.
