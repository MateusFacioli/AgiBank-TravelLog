//
//  TravelMenuViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import SwiftUI

/**
 ViewModel responsável por filtrar, carregar e organizar destinos de viagem conforme categoria no menu.
 Centraliza lógica do menu principal de viagens, filtrando por categorias e controlando loading.

 - Author: Equipe AgiBank-TravelLog

 Modificadores especiais usados:
 - @MainActor: Garante que toda a lógica, atualizações e notificações de UI ocorram na thread principal.
 - @Published: Permite que propriedades publiquem notificações reativas para SwiftUI (explicado na primeira ocorrência).
 - private: Garante o encapsulamento de propriedades e métodos internos à ViewModel (explicado na primeira ocorrência).
 */
@MainActor
final class TravelMenuViewModel: ObservableObject {
    /// Categoria atualmente selecionada no menu de viagens.
    /// Usando @Published para notificar automaticamente a UI a cada alteração.
    @Published var selectedCategory: MenuItem.MenuCategory = .myTrips

    /// Lista de destinos filtrados conforme a categoria selecionada.
    @Published var filteredItems: [TravelDestination] = []

    /// Indica se os dados estão sendo carregados (estado de loading).
    @Published var isLoading = false

    /// Todos os destinos disponíveis, encapsulados para evitar alterações externas.
    private let allDestinations = MockData.travelDestinations
    private var currentCategoryData: [TravelDestination] = []

    /// Inicializa o TravelMenuViewModel com todos os destinos disponíveis.
    init() {
        filteredItems = allDestinations
        currentCategoryData = allDestinations
    }

    /// Filtra os destinos pela categoria selecionada no menu.
    /// - Parameter category: Categoria selecionada para filtragem.
    /// Atualiza a lista `filteredItems` conforme a categoria, exceto para a categoria `.ubers`.
    func filterByCategory(_ category: MenuItem.MenuCategory) {
        selectedCategory = category
        
        if category == .ubers {
            return
        }
        
        if category == .myTrips {
            filteredItems = allDestinations
        } else {
            filteredItems = allDestinations.filter { destination in
                destination.category.rawValue == category.rawValue
            }
        }
        currentCategoryData = filteredItems
    }

    /// Simula o carregamento assíncrono de destinos, atualizando o estado de loading.
    /// Em produção, buscaria dados da API.
    func loadDestinations() async {
        isLoading = true
        //MARK: TODO API
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Em produção: carregaria da API
        // filteredItems = await APIService.shared.getDestinations()
        
        isLoading = false
    }

    /// Executa a lógica para adicionar uma nova viagem (ainda não implementada).
    func addNewTrip() {
        //MARK: TODO Implementar lógica para adicionar nova viagem
        print("Adicionar nova viagem")
    }
}

