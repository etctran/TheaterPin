//
//  TMDBCastMember.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/17/25.
//

import Foundation

struct TMDBCastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    let order: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, character, order
        case profilePath = "profile_path"
    }
    
    var profileURL: String? {
        guard let profilePath = profilePath else { return nil }
        return "\(Constants.tmdbImageBaseURL)/\(Constants.ImageSizes.profile)\(profilePath)"
    }
}

struct TMDBCrewMember: Codable, Identifiable {
    let id: Int
    let name: String
    let job: String
    let department: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, job, department
        case profilePath = "profile_path"
    }
    
    var profileURL: String? {
        guard let profilePath = profilePath else { return nil }
        return "\(Constants.tmdbImageBaseURL)/\(Constants.ImageSizes.profile)\(profilePath)"
    }
}

struct TMDBCreditsResponse: Codable {
    let id: Int
    let cast: [TMDBCastMember]
    let crew: [TMDBCrewMember]
}
