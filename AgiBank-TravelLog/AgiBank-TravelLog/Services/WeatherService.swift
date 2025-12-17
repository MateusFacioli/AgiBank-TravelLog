//
//  WeatherService.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI

protocol WeatherServiceProtocol {
    func weatherColor(for condition: String) -> Color
    func additionalWeatherConditions(for condition: String) -> [AdditionalWeatherCondition]
}

class WeatherService: WeatherServiceProtocol {
    
    // MARK: - Weather Colors
    func weatherColor(for condition: String) -> Color {
        let lowerCondition = condition.lowercased()
        
        if lowerCondition.contains("sol") || lowerCondition.contains("limpo") {
            return .yellow
        } else if lowerCondition.contains("nublado") || lowerCondition.contains("nuvens") {
            return .gray
        } else if lowerCondition.contains("chuva") || lowerCondition.contains("chuvoso") {
            return .blue
        } else if lowerCondition.contains("trovão") || lowerCondition.contains("tempestade") {
            return .purple
        } else if lowerCondition.contains("neve") {
            return .cyan
        } else if lowerCondition.contains("névoa") || lowerCondition.contains("nevoeiro") {
            return .gray.opacity(0.7)
        } else {
            return .primary
        }
    }
    
    // MARK: - Additional Weather Conditions
    func additionalWeatherConditions(for condition: String) -> [AdditionalWeatherCondition] {
        let lowerCondition = condition.lowercased()
        
        if lowerCondition.contains("chuva") {
            return [
                AdditionalWeatherCondition(icon: "drop.fill", text: "Precipitação", color: .blue),
                AdditionalWeatherCondition(icon: "umbrella.fill", text: "Guardachuva", color: .blue),
                AdditionalWeatherCondition(icon: "cloud.rain.fill", text: "Chuva intensa", color: .blue)
            ]
        } else if lowerCondition.contains("sol") {
            return [
                AdditionalWeatherCondition(icon: "sun.max.fill", text: "Ensolarado", color: .yellow),
                AdditionalWeatherCondition(icon: "sunscreen.fill", text: "Proteção solar", color: .orange),
                AdditionalWeatherCondition(icon: "thermometer.sun.fill", text: "Calor", color: .red)
            ]
        } else if lowerCondition.contains("nublado") {
            return [
                AdditionalWeatherCondition(icon: "cloud.fill", text: "Nublado", color: .gray),
                AdditionalWeatherCondition(icon: "wind", text: "Vento moderado", color: .green),
                AdditionalWeatherCondition(icon: "thermometer", text: "Temperatura amena", color: .orange)
            ]
        } else if lowerCondition.contains("neve") {
            return [
                AdditionalWeatherCondition(icon: "snowflake", text: "Neve", color: .cyan),
                AdditionalWeatherCondition(icon: "thermometer.snowflake", text: "Frio intenso", color: .blue),
                AdditionalWeatherCondition(icon: "car.fill", text: "Cuidado na estrada", color: .red)
            ]
        } else {
            return []
        }
    }
    
    // MARK: - Weather Icons Mapping
    func weatherIcon(for condition: String, isDay: Bool = true) -> String {
        let lowerCondition = condition.lowercased()
        
        if lowerCondition.contains("sol") || lowerCondition.contains("limpo") {
            return isDay ? "sun.max.fill" : "moon.stars.fill"
        } else if lowerCondition.contains("nublado") {
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        } else if lowerCondition.contains("chuva") {
            return "cloud.rain.fill"
        } else if lowerCondition.contains("tempestade") || lowerCondition.contains("trovão") {
            return "cloud.bolt.fill"
        } else if lowerCondition.contains("neve") {
            return "snowflake"
        } else if lowerCondition.contains("névoa") || lowerCondition.contains("nevoeiro") {
            return "cloud.fog.fill"
        } else if lowerCondition.contains("garoa") {
            return "cloud.drizzle.fill"
        } else {
            return "questionmark.circle.fill"
        }
    }
    
    // MARK: - Weather Descriptions
    func localizedWeatherDescription(for condition: String) -> String {
        let lowerCondition = condition.lowercased()
        
        if lowerCondition.contains("sol") || lowerCondition.contains("limpo") {
            return "Céu limpo"
        } else if lowerCondition.contains("nublado") {
            return "Parcialmente nublado"
        } else if lowerCondition.contains("chuva leve") {
            return "Chuva leve"
        } else if lowerCondition.contains("chuva moderada") {
            return "Chuva moderada"
        } else if lowerCondition.contains("chuva forte") {
            return "Chuva forte"
        } else if lowerCondition.contains("tempestade") {
            return "Tempestade"
        } else if lowerCondition.contains("neve") {
            return "Neve"
        } else if lowerCondition.contains("névoa") {
            return "Névoa"
        } else {
            return condition.capitalized
        }
    }
    
    // MARK: - Weather Recommendations
    func weatherRecommendations(for weather: WeatherDataModel) -> [WeatherRecommendation] {
        var recommendations: [WeatherRecommendation] = []
        
        // Recomendações baseadas na temperatura
        if weather.temperature > 30 {
            recommendations.append(WeatherRecommendation(
                icon: "drop.fill",
                title: "Hidratação",
                description: "Beba bastante água",
                priority: .high
            ))
            recommendations.append(WeatherRecommendation(
                icon: "sunscreen.fill",
                title: "Proteção solar",
                description: "Use protetor solar FPS 30+",
                priority: .high
            ))
        } else if weather.temperature < 10 {
            recommendations.append(WeatherRecommendation(
                icon: "thermometer.snowflake",
                title: "Roupas quentes",
                description: "Use casaco e luvas",
                priority: .medium
            ))
        }
        
        // Recomendações baseadas na chuva
        if let precipitation = weather.precipitation, precipitation > 0 {
            recommendations.append(WeatherRecommendation(
                icon: "umbrella.fill",
                title: "Guarda-chuva",
                description: "Chance de chuva: \(Int(precipitation * 100))%",
                priority: precipitation > 0.3 ? .high : .medium
            ))
        }
        
        // Recomendações baseadas no vento
        if weather.windSpeed > 20 {
            recommendations.append(WeatherRecommendation(
                icon: "wind",
                title: "Vento forte",
                description: "Cuidado com objetos soltos",
                priority: .medium
            ))
        }
        
        // Recomendações baseadas no UV
        if let uvIndex = weather.uvIndex, uvIndex > 6 {
            recommendations.append(WeatherRecommendation(
                icon: "sun.max.trianglebadge.exclamationmark.fill",
                title: "Índice UV alto",
                description: "Evite exposição prolongada",
                priority: .high
            ))
        }
        
        return recommendations
    }
}
