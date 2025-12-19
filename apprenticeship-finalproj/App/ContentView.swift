//
//  ContentView.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/17/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            LibraryView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Library")
                }
            
            TheaterMapView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Theaters")
                }
        }
        .accentColor(AppTheme.primary)
        .background(AppTheme.background)
    }
}

struct MapView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Map View")
                    .font(.largeTitle)
                Text("todo")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Theaters")
        }
    }
}

#Preview {
    ContentView()
}
