//
//  FavoritesViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 24/12/25.
//

import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favoriteDestinations: [TravelDestination] = []
    @Published var isLoading = false
    
    private let favoritesService = FavoritesService.shared
    private let allDestinations: [TravelDestination]
    
    init(destinations: [TravelDestination] = MockData.travelDestinations) {
        self.allDestinations = destinations
        loadFavorites()
    }
    
    func loadFavorites() {
        isLoading = true
        
        let favoriteIds = favoritesService.getAllFavorites()
        favoriteDestinations = allDestinations.filter { destination in
            favoriteIds.contains(destination.id)
        }
        
        isLoading = false
    }
    
    func toggleFavorite(for destination: TravelDestination) {
        let isNowFavorite = favoritesService.toggleFavorite(destinationId: destination.id)
        
        if isNowFavorite {
            if !favoriteDestinations.contains(where: { $0.id == destination.id }) {
                favoriteDestinations.append(destination)
            }
        } else {
            favoriteDestinations.removeAll { $0.id == destination.id }
        }
        
        objectWillChange.send()
    }
    
    func isFavorite(_ destination: TravelDestination) -> Bool {
        return favoritesService.isFavorite(destinationId: destination.id)
    }
    
    func clearAllFavorites() {
        favoritesService.clearAllFavorites()
        favoriteDestinations.removeAll()
    }
}
