//
//  FavoritesViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 24/12/25.
//

import SwiftUI
/**
 ViewModel responsável por gerenciar destinos favoritos do usuário.
 Realiza operações de consulta, adição, remoção e listagem dos favoritos.
 Centraliza lógica para exibir estados (carregando, vazio, etc) na interface.

 - Author: Equipe AgiBank-TravelLog

 Modificadores especiais usados:
 - @MainActor: Garante que toda a lógica, atualizações e notificações de UI ocorram na thread principal.
 - @Published: Permite que propriedades publiquem notificações reativas para SwiftUI (explicado na primeira ocorrência).
 - private: Garante o encapsulamento de propriedades e métodos internos à ViewModel (explicado na primeira ocorrência).
 */
@MainActor
final class FavoritesViewModel: ObservableObject {
    /// Lista de destinos favoritos do usuário.
    /// Usando @Published para notificar automaticamente a UI a cada alteração.
    @Published var favoriteDestinations: [TravelDestination] = []
    /// Indica se a ViewModel está atualmente carregando dados.
    @Published var isLoading = false
    
    /// Serviço responsável por gerenciar o armazenamento dos favoritos.
    /// Usado como propriedade privada para encapsular o acesso e evitar manipulação externa.
    private let favoritesService = FavoritesService.shared
    private let allDestinations: [TravelDestination]
    
    /// Inicializa o FavoritesViewModel, carregando os favoritos atuais.
    init(destinations: [TravelDestination] = MockData.travelDestinations) {
        self.allDestinations = destinations
        loadFavorites()
    }
    
    /// Carrega os destinos favoritos, atualizando a lista e o estado de carregamento.
    func loadFavorites() {
        isLoading = true
        
        let favoriteIds = favoritesService.getAllFavorites()
        favoriteDestinations = allDestinations.filter { destination in
            favoriteIds.contains(destination.id)
        }
        
        isLoading = false
    }
    
    /**
     Alterna o estado de favorito de um destino.
     
     - Parameter destination: Destino cujo estado de favorito será alternado.
     - Comportamento: Adiciona ou remove o destino da lista de favoritos e atualiza o armazenamento.
     */
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
    
    /**
     Verifica se um destino é favorito.
     
     - Parameter destination: Destino a ser verificado.
     - Returns: `true` se o destino está marcado como favorito, `false` caso contrário.
     */
    func isFavorite(_ destination: TravelDestination) -> Bool {
        return favoritesService.isFavorite(destinationId: destination.id)
    }
    
    /// Remove todos os destinos da lista de favoritos e limpa o armazenamento.
    func clearAllFavorites() {
        favoritesService.clearAllFavorites()
        favoriteDestinations.removeAll()
    }
}

