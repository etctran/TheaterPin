//
//  TMDBGenre.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/17/25.
//

import Foundation

struct TMDBGenre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct TMDBGenreResponse: Codable {
    let genres: [TMDBGenre]
}
