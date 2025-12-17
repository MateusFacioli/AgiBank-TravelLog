//
//  WeatherDataModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import SwiftUI

// MARK: - Weather Models
struct WeatherDataModel: Codable, Equatable {
    let temperature: Double
    let condition: String
    let icon: String
    let humidity: Double
    let windSpeed: Double
    let feelsLike: Double?
    let precipitation: Double?
    let uvIndex: Double?
    let lastUpdated: Date
}

struct AdditionalWeatherCondition: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let text: String
    let color: Color
    
    static func == (lhs: AdditionalWeatherCondition, rhs: AdditionalWeatherCondition) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct WeatherRecommendation: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let priority: Priority
    
    enum Priority: Comparable {
        case low, medium, high
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .red
            }
        }
        
        var order: Int {
            switch self {
            case .low: return 0
            case .medium: return 1
            case .high: return 2
            }
        }
    }
}
