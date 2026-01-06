//
//  FavoritesService.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 24/12/25.
//

import Foundation

/// Serviço singleton responsável por armazenar e gerenciar IDs de destinos favoritos.
///
/// Persistência: usa `UserDefaults` com chave `com.agibank.travelLog.favorites`.
final class FavoritesService {
    /// Instância compartilhada.
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
    
    /// Verifica se um destino é favorito.
    /// - Parameter destinationId: id do destino.
    /// - Returns: `true` se estiver nos favoritos.
    func isFavorite(destinationId: UUID) -> Bool {
        return favoriteIds.contains(destinationId)
    }
    
    /// Adiciona um destino aos favoritos.
    /// - Parameter destinationId: id do destino.
    func addFavorite(destinationId: UUID) {
        favoriteIds.insert(destinationId)
        saveFavorites()
    }
    
    /// Remove um destino dos favoritos.
    /// - Parameter destinationId: id do destino.
    func removeFavorite(destinationId: UUID) {
        favoriteIds.remove(destinationId)
        saveFavorites()
    }
    
    /// Alterna o estado favorito de um destino.
    /// - Parameter destinationId: id do destino.
    /// - Returns: `true` se agora é favorito, `false` se foi removido.
    func toggleFavorite(destinationId: UUID) -> Bool {
        if isFavorite(destinationId: destinationId) {
            removeFavorite(destinationId: destinationId)
            return false
        } else {
            addFavorite(destinationId: destinationId)
            return true
        }
    }
    
    /// Retorna todos os IDs favoritos.
    func getAllFavorites() -> Set<UUID> {
        return favoriteIds
    }
    
    /// Remove todos os favoritos e persiste a alteração.
    func clearAllFavorites() {
        favoriteIds.removeAll()
        saveFavorites()
    }
    
    // MARK: - Private Methods
    
    /// Persiste o conjunto de IDs no UserDefaults.
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteIds) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}
