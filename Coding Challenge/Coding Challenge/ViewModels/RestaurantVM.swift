//
//  RestaurantVM.swift
//  Coding Challenge
//
//  Created by omar on 14/3/2025.
//

import Foundation
import CoreLocation


class RestaurantViewModel: NSObject,ObservableObject, CLLocationManagerDelegate {
    
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var searchText: String = ""
    @Published var isLocationAuthorized = false
    
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    private let proximityThreshold = 3000.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        restaurants = MockData.restaurants
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func updateSearchResults() {
        if searchText.isEmpty {
            filteredRestaurants = isLocationAuthorized ?
                restaurants.filter { $0.distance ?? Double.infinity <= proximityThreshold } :
                restaurants
        } else {
            filteredRestaurants = restaurants.filter { restaurant in
                let nameMatch = restaurant.name.localizedCaseInsensitiveContains(searchText)
                let descMatch = restaurant.description.localizedCaseInsensitiveContains(searchText)
                let isNearby = isLocationAuthorized ? (restaurant.distance ?? Double.infinity <= proximityThreshold) : true
                
                return (nameMatch || descMatch) && isNearby
            }
        }
    }
    
    private func updateDistances() {
        guard let userLocation = userLocation else { return }
        
        for i in 0..<restaurants.count {
            let restaurantLocation = CLLocation(
                latitude: restaurants[i].latitude,
                longitude: restaurants[i].longitude
            )
            
            restaurants[i].distance = userLocation.distance(from: restaurantLocation)
        }
        
        updateSearchResults()
    }
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                isLocationAuthorized = true
                locationManager.startUpdatingLocation()
            default:
                isLocationAuthorized = false
                updateSearchResults()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            userLocation = location
            updateDistances()
            locationManager.stopUpdatingLocation()
        }
}


struct MockData {
    static let restaurants = [
        Restaurant(
            name: "Pasta Paradise",
            description: "Authentic Italian cuisine with homemade pasta",
            imageName: "pasta",
            latitude: 37.7749,
            longitude: -122.4194,
            distance: nil
        ),
        Restaurant(
            name: "Sushi Stop",
            description: "Fresh Japanese delicacies and creative rolls",
            imageName: "sushi",
            latitude: 37.7848,
            longitude: -122.4074,
            distance: nil
        ),
        Restaurant(
            name: "Burger Bar",
            description: "Juicy gourmet burgers with house-made sauces",
            imageName: "burger",
            latitude: 37.7647,
            longitude: -122.4371,
            distance: nil
        ),
        Restaurant(
            name: "Taco Time",
            description: "Authentic Mexican street food and fresh margaritas",
            imageName: "taco",
            latitude: 37.7833,
            longitude: -122.4167,
            distance: nil
        ),
        Restaurant(
            name: "Pizza Place",
            description: "Wood-fired Neapolitan pizzas with artisanal toppings",
            imageName: "pizza",
            latitude: 37.7694,
            longitude: -122.4862,
            distance: nil
        ),
        Restaurant(
            name: "Curry House",
            description: "Flavorful Indian curries and fresh naan bread",
            imageName: "curry",
            latitude: 37.7691,
            longitude: -122.4092,
            distance: nil
        ),
        Restaurant(
            name: "Noodle Bar",
            description: "Hand-pulled noodles and authentic Asian soups",
            imageName: "noodles",
            latitude: 37.7541,
            longitude: -122.4382,
            distance: nil
        ),
        Restaurant(
            name: "Breakfast Club",
            description: "All-day breakfast classics and gourmet coffee",
            imageName: "breakfast",
            latitude: 37.7841,
            longitude: -122.4344,
            distance: nil
        )
    ]
}
