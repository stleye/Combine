//
//  Fetch1.swift
//  Networking
//
//  Created by Sebastian Tleye on 14/03/2024.
//

import Foundation
import Combine

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum NetworkError: Error {
    case badServerResponse
}

struct Fetch1 {
    
    var cancellables = Set<AnyCancellable>()
    var pub: AnyPublisher<[Post], Error>?
    
    mutating func run() {
        fetchPost()
            .sink { completion in
                switch completion {
                case .finished:
                    print("Update UI")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { posts in
                print(posts)
            }
            .store(in: &cancellables)
    }

    func fetchPost() -> AnyPublisher<[Post], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ data, response in
                print ("retries")
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw NetworkError.badServerResponse
                }
                return data
            })
            .decode(type: [Post].self, decoder: JSONDecoder())
            .retry(3)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
