//
//  TravelViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import SwiftUI

@MainActor
class TravelViewModel: ObservableObject {
    @Published var destinations: [TravelDestination] = []
    @Published var selectedCategory: TravelDestination.TravelCategory?
    @Published var isLoading = false
    @Published var error: String?
    
    private let repository: TravelRepository
    
    init(repository: TravelRepository = TravelRepository.shared) {
        self.repository = repository
    }
    
    func loadDestinations() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            destinations = try await repository.fetchDestinations()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func addDestination(_ destination: TravelDestination) async {
        do {
            try await repository.saveDestination(destination)
            await loadDestinations()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    var filteredDestinations: [TravelDestination] {
        guard let category = selectedCategory else { return destinations }
        return destinations.filter { $0.category == category }
    }
}
