//
//  MoviesSwiftUIApp.swift
//  MoviesSwiftUI
//
//  Created by Sebastian Tleye on 16/03/2024.
//

import SwiftUI

@main
struct MoviesSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(httpClient: HTTPClient())
        }
    }
}
