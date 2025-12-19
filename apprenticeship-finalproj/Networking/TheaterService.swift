//
//  TheaterService.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/19/25.
//

import Foundation
import MapKit
import CoreLocation
import Observation

@MainActor
@Observable
class TheaterService: NSObject {
    static let shared = TheaterService()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func searchNearbyTheaters(near location: CLLocation? = nil) async throws -> [Theater] {
        let searchLocation = location ?? currentLocation
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "movie theater"
        
        if let searchLocation = searchLocation {
            let region = MKCoordinateRegion(
                center: searchLocation.coordinate,
                latitudinalMeters: 20000,
                longitudinalMeters: 20000
            )
            request.region = region
        }
        
        let search = MKLocalSearch(request: request)
        
        return try await withCheckedThrowingContinuation { continuation in
            search.start { response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let response = response else {
                    continuation.resume(throwing: NSError(domain: "TheaterSearchError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No search results"]))
                    return
                }
                
                let theaters = response.mapItems.map { mapItem in
                    Theater(from: mapItem, userLocation: searchLocation)
                }
                
                let sortedTheaters = theaters.sorted { first, second in
                    guard let firstDistance = first.distance,
                          let secondDistance = second.distance else {
                        return first.name < second.name
                    }
                    return firstDistance < secondDistance
                }
                
                continuation.resume(returning: sortedTheaters)
            }
        }
    }
    
    func searchTheaters(in city: String) async throws -> [Theater] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "movie theater in \(city)"
        
        let search = MKLocalSearch(request: request)
        
        return try await withCheckedThrowingContinuation { continuation in
            search.start { response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let response = response else {
                    continuation.resume(throwing: NSError(domain: "TheaterSearchError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No search results"]))
                    return
                }
                
                let theaters = response.mapItems.map { mapItem in
                    Theater(from: mapItem, userLocation: self.currentLocation)
                }
                
                continuation.resume(returning: theaters)
            }
        }
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension TheaterService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}
