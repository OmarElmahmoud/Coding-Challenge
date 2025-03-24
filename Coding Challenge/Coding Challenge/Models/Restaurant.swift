//
//  Restaurant.swift
//  Coding Challenge
//
//  Created by omar on 14/3/2025.
//

import Foundation

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageName: String
    let latitude: Double
    let longitude: Double
}
