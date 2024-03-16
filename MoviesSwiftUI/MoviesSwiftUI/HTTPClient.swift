//
//  HTTPClient.swift
//  MoviesSwiftUI
//
//  Created by Sebastian Tleye on 16/03/2024.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badURL
}

class HTTPClient {
    
    func fetchMovies(search: String) -> AnyPublisher<[Movie], Error> {
        guard let encodedSearch = search.urlEncoded(), let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&page=2&apiKey=d1360984") else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.Search)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .print()
            .eraseToAnyPublisher()
    }
    
    
}


extension String {
    func urlEncoded() -> String? {
        let allowedCharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}
