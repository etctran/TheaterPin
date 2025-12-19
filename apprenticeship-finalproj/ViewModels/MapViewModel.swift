//
//  TheatersMapViewModel.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import Foundation
import MapKit
import CoreLocation
import Observation

@MainActor
@Observable
class TheatersMapViewModel {
    var theaters: [Theater] = []
    var annotations: [TheaterAnnotation] = []
    var isLoading = false
    var errorMessage: String?
    
    let geocoder = CLGeocoder()
    let theaterService = TheaterService.shared
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let searchResults = try await theaterService.searchNearbyTheaters()
            self.theaters = searchResults
            
            annotations.removeAll()
            for theater in searchResults {
                annotations.append(TheaterAnnotation(theater: theater))
            }
        } catch {
            errorMessage = "Failed to load theaters"
        }
        
        isLoading = false
    }
    
    func searchTheaters(in city: String) async {
        guard !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let searchResults = try await theaterService.searchTheaters(in: city)
            self.theaters = searchResults
            
            annotations.removeAll()
            for theater in searchResults {
                annotations.append(TheaterAnnotation(theater: theater))
            }
        } catch {
            errorMessage = "Failed to find theaters in \(city)"
        }
        
        isLoading = false
    }
}
