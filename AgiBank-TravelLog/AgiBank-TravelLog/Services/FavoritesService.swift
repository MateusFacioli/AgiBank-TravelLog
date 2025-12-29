//
//  FavoritesService.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 24/12/25.
//

import Foundation

final class FavoritesService {
    static let shared = FavoritesService()
    
    private let favoritesKey = "com.agibank.travelLog.favorites"
    private var favoriteIds: Set<UUID>
    
    private init() {
        // Carrega favoritos do UserDefaults
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let ids = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            favoriteIds = ids
        } else {
            favoriteIds = []
        }
    }
    
    // MARK: - Public Methods
    func isFavorite(destinationId: UUID) -> Bool {
        return favoriteIds.contains(destinationId)
    }
    
    func addFavorite(destinationId: UUID) {
        favoriteIds.insert(destinationId)
        saveFavorites()
    }
    
    func removeFavorite(destinationId: UUID) {
        favoriteIds.remove(destinationId)
        saveFavorites()
    }
    
    func toggleFavorite(destinationId: UUID) -> Bool {
        if isFavorite(destinationId: destinationId) {
            removeFavorite(destinationId: destinationId)
            return false
        } else {
            addFavorite(destinationId: destinationId)
            return true
        }
    }
    
    func getAllFavorites() -> Set<UUID> {
        return favoriteIds
    }
    
    func clearAllFavorites() {
        favoriteIds.removeAll()
        saveFavorites()
    }
    
    // MARK: - Private Methods
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteIds) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}
