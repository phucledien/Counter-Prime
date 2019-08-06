//
//  AppState.swift
//  Counter
//
//  Created by Phuc Le Dien on 8/2/19.
//  Copyright © 2019 Dwarves Foundation. All rights reserved.
//

import SwiftUI
import Combine

class AppState: BindableObject, Codable {
    var didChange = PassthroughSubject<Void, Never>()
    
    var count = 0 {
        didSet {
            didChange.send()
            saveToUserDefault()
        }
    }
    
    var favoritePrimes: [Int] = [] {
        didSet {
            didChange.send()
            saveToUserDefault()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case favoritePrimes = "favoritePrimes"
    }
    
    private func saveToUserDefault() {
        let appStateJson = try? JSONEncoder().encode(self)
        UserDefaults.standard.set(appStateJson, forKey: "AppState")
    }
}
