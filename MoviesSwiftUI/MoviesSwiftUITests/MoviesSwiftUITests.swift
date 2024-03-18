//
//  MoviesSwiftUITests.swift
//  MoviesSwiftUITests
//
//  Created by Sebastian Tleye on 18/03/2024.
//

import XCTest
import Combine

final class MoviesSwiftUITests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()

    func testFetchMovies() {
        let httpClient = HTTPClient()
        let expectation = XCTestExpectation(description: "Received Movies")
        
        httpClient.fetchMovies(search: "Batman")
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Request Failed with error \(error)")
                }
            } receiveValue: { movies in
                XCTAssertTrue(movies.count > 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }

}
