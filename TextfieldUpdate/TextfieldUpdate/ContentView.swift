//
//  ContentView.swift
//  TextfieldUpdate
//
//  Created by Sebastian Tleye on 03/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("\(viewModel.value)")
        }
        .padding()
    }
}






#Preview {
    ContentView()
}
