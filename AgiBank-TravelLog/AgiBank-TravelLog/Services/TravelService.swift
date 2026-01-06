//
//  TravelService.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import Foundation

/// Serviço que encapsula a comunicação com a API para operações de destinos.
/// Implementa `TravelServiceProtocol` para permitir substituição em testes.
protocol TravelServiceProtocol {
    func fetchDestinations() async throws -> [TravelDestination]
    func saveDestination(_ destination: TravelDestination) async throws
    func uploadPhoto(_ imageData: Data) async throws -> String
}

class TravelService: TravelServiceProtocol {
    private let apiClient = APIClient()
    
    /// Busca destinos via API.
    func fetchDestinations() async throws -> [TravelDestination] {
        let endpoint = APIEndpoint.destinations
        return try await apiClient.request(endpoint)
    }
    
    /// Salva um destino via API.
    func saveDestination(_ destination: TravelDestination) async throws {
        let endpoint = APIEndpoint.saveDestination(destination)
        try await apiClient.request(endpoint)
    }
    
    /// Faz upload de foto e retorna a URL como `String`.
    func uploadPhoto(_ imageData: Data) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let url = try await apiClient.upload(data: imageData)
                    continuation.resume(returning: url.absoluteString)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
