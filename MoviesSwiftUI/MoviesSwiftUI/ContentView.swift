//
//  ContentView.swift
//  MoviesSwiftUI
//
//  Created by Sebastian Tleye on 16/03/2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var movies: [Movie] = []
    @State private var search = ""
    
    private let searchSubject = CurrentValueSubject<String, Never>("")
    @State private var cancellables = Set<AnyCancellable>()
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    private func setupSearchSubject() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { searchText in
                loadMovies(search: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func loadMovies(search: String) {
        httpClient.fetchMovies(search: search)
            .sink { response in
                switch response {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { movies in
                self.movies = movies
            }
            .store(in: &cancellables)
    }
    
    var body: some View {
        NavigationStack {
            List(movies) { movie in
                HStack {
                    AsyncImage(url: movie.poster) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                    } placeholder: {
                        ProgressView()
                    }
                    Text(movie.title)
                }
            }
            .onAppear {
                setupSearchSubject()
            }
            .searchable(text: $search)
            .onChange(of: search) {
                searchSubject.send(search)
            }
        }
    }
}

#Preview {
    ContentView(httpClient: HTTPClient())
}
