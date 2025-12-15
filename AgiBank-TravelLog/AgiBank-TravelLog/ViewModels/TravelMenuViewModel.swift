//
//  TravelMenuViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import SwiftUI
import Foundation


class TravelMenuViewModel: ObservableObject {
    @Published var selectedCategory: MenuItem.MenuCategory = .myTrips
    @Published var filteredItems: [TravelDestination] = []
    @Published var isLoading: Bool = false
    
    private let allDestinations: [TravelDestination] = [
        TravelDestination(
            id: UUID(),
            name: "Paris, França",
            location: "Europa",
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
            rating: 4.8,
            notes: "Conhecida como a Cidade Luz, Paris é famosa por sua arquitetura icônica, museus de classe mundial e culinária refinada.",
            photos: ["https://images.unsplash.com/photo-1502602898457-c46ad927bd85?w=800"],
            category: .relax
        ),
        TravelDestination(
            id: UUID(),
            name: "Rio de Janeiro",
            location: "Brasil",
            startDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
            endDate: Calendar.current.date(byAdding: .month, value: -1, to: Calendar.current.date(byAdding: .day, value: 10, to: Date())!)!,
            rating: 4.7,
            notes: "Cidade maravilhosa com praias famosas e o Cristo Redentor.",
            photos: ["https://images.unsplash.com/photo-1483729558449-99ef09a8c325?w=800"],
            category: .adventure
        ),
        TravelDestination(
            id: UUID(),
            name: "Tóquio, Japão",
            location: "Ásia",
            startDate: Calendar.current.date(byAdding: .month, value: 2, to: Date())!,
            endDate: Calendar.current.date(byAdding: .month, value: 2, to: Calendar.current.date(byAdding: .day, value: 14, to: Date())!)!,
            rating: 4.9,
            notes: "Metrópole vibrante combinando tradição e tecnologia de ponta.",
            photos: ["https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w-800"],
            category: .solo
        ),
    ]
    
    func filterByCategory(_ category: MenuItem.MenuCategory) {
        selectedCategory = category
        
        if category == .myTrips {
            filteredItems = allDestinations.filter {
                $0.category == .relax     ||
                $0.category == .adventure ||
                $0.category == .solo      ||
                $0.category == .family    ||
                $0.category == .business
                
            }
        } else {
            filteredItems = allDestinations.filter { $0.category.rawValue == category.rawValue }
            // filteredItems = []
        }
    }
    
    func loadDestinations() async {
        isLoading = true
        
        // Simular carregamento de dados da API
        //MARK: TODO API
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
        
        DispatchQueue.main.async {
            self.filterByCategory(.myTrips)
            self.isLoading = false
        }
    }
    
    func addNewTrip() {
        //MARK: TODO Implementar lógica para adicionar nova viagem
        print("Adicionar nova viagem")
    }
}
