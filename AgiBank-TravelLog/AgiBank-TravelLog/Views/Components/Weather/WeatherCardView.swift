//
//  WeatherCardView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI

struct WeatherCardView: View {
    let weather: WeatherDataModel
    let additionalConditions: [AdditionalWeatherCondition]
    let weatherService: WeatherServiceProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Condições do Tempo")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            HStack(spacing: 16) {
                // Ícone principal do tempo
                VStack(spacing: 4) {
                    Image(systemName: weather.icon)
                        .font(.system(size: 32))
                        .foregroundStyle(weatherService.weatherColor(for: weather.condition))
                    
                    Text(weather.condition)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 60)
                
                // Temperatura
                weatherInfoView(
                    icon: "thermometer",
                    title: "Temperatura",
                    value: "\(weather.temperature)°C",
                    color: .orange
                )
                
                // Umidade
                weatherInfoView(
                    icon: "humidity",
                    title: "Umidade",
                    value: "\(weather.humidity)%",
                    color: .blue
                )
                
                // Vento
                weatherInfoView(
                    icon: "wind",
                    title: "Vento",
                    value: "\(String(format: "%.1f", weather.windSpeed)) km/h",
                    color: .green
                )
            }
            
            // Condições adicionais
            if !additionalConditions.isEmpty {
                HStack(spacing: 12) {
                    ForEach(additionalConditions) { condition in
                        HStack(spacing: 4) {
                            Image(systemName: condition.icon)
                                .font(.caption2)
                                .foregroundStyle(condition.color)
                            
                            Text(condition.text)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func weatherInfoView(
        icon: String,
        title: String,
        value: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}
