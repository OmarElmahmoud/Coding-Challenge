//
//  RestaurantVM.swift
//  Coding Challenge
//
//  Created by omar on 14/3/2025.
//

import Foundation
import CoreLocation

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var searchText: String = ""
    @Published var isLocationAuthorized = false

    private let locationService = LocationService()
    private let proximityThreshold = 3000.0
    private var updatedLocation:CLLocation?
    
    init() {
        restaurants = MockData.restaurants
        locationService.onLocationUpdate = { [weak self] location in
            self?.updatedLocation = location
            self?.updateRestaurantResults()
        }
        locationService.onAuthorizationChange = { [weak self] isAuthorized in
            self?.isLocationAuthorized = isAuthorized
            self?.updateRestaurantResults()
        }
    }
    func requestLocationPermission() {
        locationService.requestLocationPermission()
    }
    func updateRestaurantResults() {
        let searchFiltered = searchText.isEmpty ? restaurants : restaurants.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
        filteredRestaurants = isLocationAuthorized ? searchFiltered.filter { restaurant in
            guard let userLocation = updatedLocation else { return false }
            let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
            return userLocation.distance(from: restaurantLocation) <= proximityThreshold
        } : searchFiltered
    }
}

struct MockData {
    static let restaurants = [
        Restaurant(
            name: "Pasta Paradise",
            description: "Authentic Italian cuisine with homemade pasta",
            imageName: "pasta",
            latitude: 37.7749,
            longitude: -122.4194
        ),
        Restaurant(
            name: "Sushi Stop",
            description: "Fresh Japanese delicacies and creative rolls",
            imageName: "sushi",
            latitude: 37.7848,
            longitude: -122.4074
        ),
        Restaurant(
            name: "Burger Bar",
            description: "Juicy gourmet burgers with house-made sauces",
            imageName: "burger",
            latitude: 37.7647,
            longitude: -122.4371
        ),
        Restaurant(
            name: "Taco Time",
            description: "Authentic Mexican street food and fresh margaritas",
            imageName: "taco",
            latitude: 37.7833,
            longitude: -122.4167
        ),
        Restaurant(
            name: "Pizza Place",
            description: "Wood-fired Neapolitan pizzas with artisanal toppings",
            imageName: "pizza",
            latitude: 37.7694,
            longitude: -122.4862
        ),
        Restaurant(
            name: "Curry House",
            description: "Flavorful Indian curries and fresh naan bread",
            imageName: "curry",
            latitude: 37.7691,
            longitude: -122.4092
        ),
        Restaurant(
            name: "Noodle Bar",
            description: "Hand-pulled noodles and authentic Asian soups",
            imageName: "noodles",
            latitude: 37.7541,
            longitude: -122.4382
        ),
        Restaurant(
            name: "Breakfast Club",
            description: "All-day breakfast classics and gourmet coffee",
            imageName: "breakfast",
            latitude: 37.7841,
            longitude: -122.4344
        )
    ]
}
