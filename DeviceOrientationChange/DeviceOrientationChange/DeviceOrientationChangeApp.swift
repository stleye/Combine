//
//  DeviceOrientationChangeApp.swift
//  DeviceOrientationChange
//
//  Created by Sebastian Tleye on 03/03/2024.
//

import SwiftUI
import Combine

@main
struct DeviceOrientationChangeApp: App {
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { _ in
                let currentOrientation = UIDevice.current.orientation
                print("Device Orientation Changed - \(currentOrientation.toString)")
            }
            .store(in: &cancellables)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension UIDeviceOrientation {
    var toString: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .portrait:
            return "Portrait"
        case .portraitUpsideDown:
            return "Portrait Upside Down"
        case .landscapeLeft:
            return "Landscape Left"
        case .landscapeRight:
            return "Landscape Right"
        case .faceUp:
            return "Face Up"
        case .faceDown:
            return "Face Down"
        @unknown default:
            return "Unknown"
        }
    }
}
