//
//  Movie.swift
//  MoviesSwiftUI
//
//  Created by Sebastian Tleye on 16/03/2024.
//

import Foundation

struct MovieResponse: Decodable {
    let Search: [Movie]
}

struct Movie: Identifiable, Decodable {
    let title: String
    let year: String
    let imdbId: String
    let poster: URL?
    
    var id: String {
        imdbId
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbId = "imdbID"
        case poster = "Poster"
    }
}
