//
//  ContentView.swift
//  Coding Challenge
//
//  Created by omar on 14/3/2025.
//

import SwiftUI

struct RestaurantListView: View {
    @StateObject private var viewModel = RestaurantViewModel()
        
        var body: some View {
            NavigationView {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search restaurants", text: $viewModel.searchText)
                            .onChange(of: viewModel.searchText) { _ in
                                viewModel.updateSearchResults()
                            }
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                                viewModel.updateSearchResults()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: viewModel.isLocationAuthorized ? "location.fill" : "location.slash")
                        Text(viewModel.isLocationAuthorized ?
                             "Restaurants within 3km" :
                             "All restaurants")
                        Spacer()
                    }
                    .font(.caption)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    
                    if viewModel.filteredRestaurants.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "fork.knife.circle")
                                .font(.system(size: 64))
                                .foregroundColor(.gray)
                            
                            Text("No restaurants found")
                                .font(.headline)
                            
                            Text("Try a different search term or location setting")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(viewModel.filteredRestaurants) { restaurant in
                                RestaurantRow(restaurant: restaurant)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .navigationTitle("Restaurants")
                .onAppear {
                    viewModel.requestLocationPermission()
                }
            }
        }
    }

struct RestaurantRow: View {
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 12) {
            Image(restaurant.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.headline)
                
                Text(restaurant.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if let distance = restaurant.distance {
                    Text(String(format: "%.1f km away", distance / 1000))
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    RestaurantListView()
}
