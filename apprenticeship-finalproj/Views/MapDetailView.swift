//
//  MapDetailView.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/21/25.
//

import SwiftUI

struct MapDetailView: View {
    let theater: Theater
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(theater.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if !theater.formattedDistance.isEmpty {
                    Text(theater.formattedDistance + " away")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Label("Address", systemImage: "location")
                    .font(.headline)
                
                Text(theater.formattedAddress)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            if let phoneNumber = theater.phoneNumber {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Phone", systemImage: "phone")
                        .font(.headline)
                    
                    Text(phoneNumber)
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
            
            VStack(spacing: 12) {
                Button {
                    openInMaps()
                } label: {
                    HStack {
                        Image(systemName: "map")
                        Text("Get Directions")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                if theater.phoneNumber != nil {
                    Button {
                        callTheater()
                    } label: {
                        HStack {
                            Image(systemName: "phone")
                            Text("Call Theater")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .padding()
    }
    
    func openInMaps() {
        let placemark = MKPlacemark(coordinate: theater.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = theater.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    func callTheater() {
        guard let phoneNumber = theater.phoneNumber,
              let url = URL(string: "tel://\(phoneNumber)") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

import MapKit
import UIKit

#Preview {
    MapDetailView(theater: Theater(
        from: MKMapItem(),
        userLocation: nil
    ))
}
