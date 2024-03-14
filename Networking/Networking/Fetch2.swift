//
//  Fetch2.swift
//  Networking
//
//  Created by Sebastian Tleye on 14/03/2024.
//

import Foundation
import Combine

struct MovieResponse: Decodable {
    let Search: [Movie]
}

struct Movie: Decodable {
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
    }
}

struct Fetch2 {
    
    var cancellables = Set<AnyCancellable>()
    
    mutating func run() {
        let publisher = Publishers.CombineLatest(fetchMovies("Batman"), fetchMovies("Superman"))
        publisher.sink { response in
            switch response {
            case .finished:
                print("Finished")
            case .failure(let error):
                print(error)
            }
        } receiveValue: { value1, value2 in
            print(value1.Search)
            print(value2.Search)
        }
        .store(in: &cancellables)

    }
    
    func fetchMovies(_ searchTerm: String) -> AnyPublisher<MovieResponse, Error> {
        let url = URL(string: "https://www.omdbapi.com/?s=\(searchTerm)&page=2&apiKey=564727fa")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
}
