//
//  Theater.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/17/25.
//

import Foundation
import MapKit
import CoreLocation

struct Theater: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let phoneNumber: String?
    let distance: CLLocationDistance?
    
    init(from mapItem: MKMapItem, userLocation: CLLocation? = nil) {
        self.name = mapItem.name ?? "Unknown Theater"
        
        let placemark = mapItem.placemark
        var addressComponents: [String] = []
        
        if let thoroughfare = placemark.thoroughfare {
            addressComponents.append(thoroughfare)
        }
        if let locality = placemark.locality {
            addressComponents.append(locality)
        }
        if let administrativeArea = placemark.administrativeArea {
            addressComponents.append(administrativeArea)
        }
        
        self.address = addressComponents.isEmpty ? "Address unavailable" : addressComponents.joined(separator: ", ")
        self.coordinate = mapItem.placemark.coordinate
        self.phoneNumber = mapItem.phoneNumber
        
        if let userLocation = userLocation {
            let theaterLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.distance = userLocation.distance(from: theaterLocation)
        } else {
            self.distance = nil
        }
    }
    
    var formattedDistance: String {
        guard let distance = distance else { return "" }
        let miles = distance * 0.000621371
        return String(format: "%.1f mi", miles)
    }
    
    var formattedAddress: String {
        return address
    }
}

struct TheaterAnnotation: Identifiable {
    let id = UUID()
    let theater: Theater
    let coordinate: CLLocationCoordinate2D
    
    init(theater: Theater) {
        self.theater = theater
        self.coordinate = theater.coordinate
    }
}
