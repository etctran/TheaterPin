//
//  TMDBService.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/19/25.
//

import Foundation
import Observation

@Observable
class TMDBService {
    static let shared = try! TMDBService()
    
    let baseURL: URL
    
    init() throws {
        guard let url = URL(string: "https://api.themoviedb.org/3/") else {
            throw NetworkError.invalidURL
        }
        self.baseURL = url
    }
    
    func fetchTrendingMovies() async throws -> [TMDBMovie] {
        guard let url = URL(string: "trending/movie/day?api_key=\(Constants.tmdbAPIKey)", relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(TMDBMovieResponse.self, from: data)
                return response.results
            } catch {
                throw NetworkError.decodingError
            }
        } catch is URLError {
            throw NetworkError.unknown
        } catch {
            throw NetworkError.unknown
        }
    }
    
    func fetchPopularMovies() async throws -> [TMDBMovie] {
        guard let url = URL(string: "movie/popular?api_key=\(Constants.tmdbAPIKey)", relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(TMDBMovieResponse.self, from: data)
                return response.results
            } catch {
                throw NetworkError.decodingError
            }
        } catch is URLError {
            throw NetworkError.unknown
        } catch {
            throw NetworkError.unknown
        }
    }
    
    func searchMovies(query: String) async throws -> [TMDBMovie] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "search/movie?api_key=\(Constants.tmdbAPIKey)&query=\(encodedQuery)", relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(TMDBMovieResponse.self, from: data)
                return response.results
            } catch {
                throw NetworkError.decodingError
            }
        } catch is URLError {
            throw NetworkError.unknown
        } catch {
            throw NetworkError.unknown
        }
    }
    
    func fetchMovieDetails(id: Int) async throws -> TMDBMovie {
        guard let url = URL(string: "movie/\(id)?api_key=\(Constants.tmdbAPIKey)", relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(TMDBMovie.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        } catch is URLError {
            throw NetworkError.unknown
        } catch {
            throw NetworkError.unknown
        }
    }
    
    func fetchMovieCredits(id: Int) async throws -> TMDBCreditsResponse {
        guard let url = URL(string: "movie/\(id)/credits?api_key=\(Constants.tmdbAPIKey)", relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(TMDBCreditsResponse.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        } catch is URLError {
            throw NetworkError.unknown
        } catch {
            throw NetworkError.unknown
        }
    }
    
    func fetchSimilarMovies(id: Int) async throws -> [TMDBMovie] {
        guard let url = URL(string: "movie/\(id)/similar?api_key=\(Constants.tmdbAPIKey)", relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(TMDBMovieResponse.self, from: data)
                return response.results
            } catch {
                throw NetworkError.decodingError
            }
        } catch is URLError {
            throw NetworkError.unknown
        } catch {
            throw NetworkError.unknown
        }
    }
}
