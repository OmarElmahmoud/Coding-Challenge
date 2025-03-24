//
//  LocationService.swift
//  Coding Challenge
//
//  Created by omar on 23/3/2025.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var onLocationUpdate: ((CLLocation?) -> Void)?
    var onAuthorizationChange: ((Bool) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
    }
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let isAuthorized = manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways
        onAuthorizationChange?(isAuthorized)

        if isAuthorized {
            startUpdatingLocation()
        } else {
            stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        onLocationUpdate?(location)
    }
}
