//
//  TravelService.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import Foundation

protocol TravelServiceProtocol {
    func fetchDestinations() async throws -> [TravelDestination]
    func saveDestination(_ destination: TravelDestination) async throws
    func uploadPhoto(_ imageData: Data) async throws -> String
}

class TravelService: TravelServiceProtocol {
    private let apiClient = APIClient()
    
    func fetchDestinations() async throws -> [TravelDestination] {
        let endpoint = APIEndpoint.destinations
        return try await apiClient.request(endpoint)
    }
    
    func saveDestination(_ destination: TravelDestination) async throws {
        let endpoint = APIEndpoint.saveDestination(destination)
        try await apiClient.request(endpoint)
    }
    
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
