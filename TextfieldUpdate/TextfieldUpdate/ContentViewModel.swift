//
//  ContentViewModel.swift
//  TextfieldUpdate
//
//  Created by Sebastian Tleye on 03/03/2024.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var value = 0
    private var cancellable: AnyCancellable?

    init(value: Int = 0) {
        let publisher = Timer.publish(every: 1.0, on: .main, in: .default)
            .autoconnect()
            .map { _ in
                self.value + 1
            }
        cancellable = publisher.assign(to: \.value, on: self)
    }
}
