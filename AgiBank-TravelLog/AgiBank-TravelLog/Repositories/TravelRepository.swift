//
//  TravelRepository.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import Foundation

protocol TravelRepositoryProtocol {
    func fetchDestinations() async throws -> [TravelDestination]
    func saveDestination(_ destination: TravelDestination) async throws
    //MARK: TODO
    //func deleteDestination(id: UUID) async throws
}

class TravelRepository: TravelRepositoryProtocol {
    
    static let shared = TravelRepository()
    private let service: TravelServiceProtocol
    
    // Dependency Injection
    init(service: TravelServiceProtocol = TravelService()) {
        self.service = service
    }
    
    func fetchDestinations() async throws -> [TravelDestination] {
        if let cached = loadFromCache() {
            return cached
        }
        
        let remoteDestinations = try await service.fetchDestinations()
        
        //MARK: TODO
        // 3. Update cache
        //saveToCache(remoteDestinations)
        
        return remoteDestinations
    }
    
    func saveDestination(_ destination: TravelDestination) async throws {
        try await service.saveDestination(destination)
        // Update cache
    }
    
    private func loadFromCache() -> [TravelDestination]? {
        // Implement Core Data/UserDefaults cache
        return nil
    }
    //MARK: TODO
//    func deleteDestination(id: UUID) async throws {
//
//    }
}
