//
//  TravelMenuViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import SwiftUI

@MainActor
final class TravelMenuViewModel: ObservableObject {
    @Published var selectedCategory: MenuItem.MenuCategory = .myTrips
    @Published var filteredItems: [TravelDestination] = []
    @Published var isLoading = false
    
    private let allDestinations = MockData.travelDestinations
    
    init() {
        filteredItems = allDestinations
    }
    
    func filterByCategory(_ category: MenuItem.MenuCategory) {
        selectedCategory = category
        
        if category == .ubers {
            return
        }
        
        if category == .myTrips {
            filteredItems = allDestinations
        } else {
            filteredItems = allDestinations.filter { $0.category.rawValue == category.rawValue }
        }
    }
    
    func loadDestinations() async {
        isLoading = true
        //MARK: TODO API
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Em produção: carregaria da API
        // filteredItems = await APIService.shared.getDestinations()
        
        isLoading = false
    }
    
    func addNewTrip() {
        //MARK: TODO Implementar lógica para adicionar nova viagem
        print("Adicionar nova viagem")
    }
}
