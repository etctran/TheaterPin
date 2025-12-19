//
//  TheaterMapView.swift
//  apprenticeship-finalproj
//
//  Created by Ethan Tran on 11/24/25.
//

import SwiftUI
import MapKit

struct TheaterMapView: View {
    @State var vm = TheatersMapViewModel()
    @State var position = MapCameraPosition.automatic
    @State var selectedTheater: Theater?
    @State var showingCitySearch = false
    
    var body: some View {
        NavigationStack {
            MapReader { proxy in
                Map(position: $position) {
                    ForEach(vm.annotations) { annotation in
                        Annotation(annotation.theater.name, coordinate: annotation.coordinate) {
                            Button {
                                selectedTheater = annotation.theater
                            } label: {
                                Image(systemName: "mappin")
                                    .font(.largeTitle)
                                    .foregroundColor(AppTheme.primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Theater Map")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Find Nearby") {
                            Task {
                                await vm.load()
                            }
                        }
                        Button("Search City") {
                            showingCitySearch = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .task {
                if vm.annotations.isEmpty {
                    await vm.load()
                }
            }
            .sheet(item: $selectedTheater) { theater in
                NavigationStack {
                    MapDetailView(theater: theater)
                        .navigationTitle("Theater Details")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    selectedTheater = nil
                                }
                            }
                        }
                }
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showingCitySearch) {
                CitySearchView(vm: vm)
            }
            .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
                Button("OK") {
                    vm.errorMessage = nil
                }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }
}

struct CitySearchView: View {
    let vm: TheatersMapViewModel
    @Environment(\.dismiss) var dismiss
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Search for theaters in a city")
                    .font(.headline)
                    .padding(.top)
                
                TextField("Enter city name", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Button("Search") {
                    Task {
                        await vm.searchTheaters(in: searchText)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(searchText.isEmpty)
                
                Spacer()
            }
            .navigationTitle("Search City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    TheaterMapView()
}
