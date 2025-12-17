//
//  DestinationCardViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//


import SwiftUI
import Combine

@MainActor
final class DestinationCardViewModel: ObservableObject {
    @Published var currentRating: Float
    @Published var enrichedData: EnrichedDestinationModel?
    @Published var isLoadingEnrichment = false
    @Published var selectedPhotoIndex = 0
    @Published var additionalWeatherConditions: [AdditionalWeatherCondition] = []
    @Published var weatherRecommendations: [WeatherRecommendation] = []
    
    private let destination: TravelDestination
    private let apiService: TransportAPIServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        destination: TravelDestination,
        apiService: TransportAPIServiceProtocol = TransportAPIService.shared,
        weatherService: WeatherServiceProtocol = WeatherService()
    ) {
        self.destination = destination
        self.apiService = apiService
        self.weatherService = weatherService
        self.currentRating = destination.rating
        
        setupWeatherObservers()
    }
    
    // MARK: - Public Methods
    func loadEnrichedData() async {
        isLoadingEnrichment = true
        
        do {
            let data = try await apiService.enrichDestination(destination)
            enrichedData = data
            updateWeatherData(for: data.weather)
        } catch {
            print("Error loading enriched data: \(error)")
        }
        
        isLoadingEnrichment = false
    }
    
    func shareDestination() -> [Any] {
        var items: [Any] = ["🎯 \(destination.name)"]
        
        if let enrichedData = enrichedData {
            if let weather = enrichedData.weather {
                items.append("\n🌤️ Clima: \(weather.temperature)°C - \(weather.condition)")
            }
            if let travelTime = enrichedData.travelTime {
                items.append("\n🚗 Tempo de viagem: \(travelTime.duration)")
            }
        }
        
        items.append("\n⭐ Avaliação: \(String(format: "%.1f", currentRating))/5.0")
        items.append("\n✍️ Minha nota: \(destination.notes)")
        
        return items
    }
    
    func shareWithWeather(_ weather: WeatherDataModel?) -> String? {
        guard let weather = weather else { return nil }
        
        return """
        🌍 Destino: \(destination.name)
        📍 Local: \(destination.location)
        🌤️ Clima: \(weather.temperature)°C - \(weather.condition)
        💧 Umidade: \(weather.humidity)%
        💨 Vento: \(weather.windSpeed) km/h
        ⭐ Minha avaliação: \(String(format: "%.1f", currentRating))/5.0
        """
    }
    
    // MARK: - Private Methods
    private func setupWeatherObservers() {
        $enrichedData
            .compactMap { $0?.weather?.condition }
            .removeDuplicates()
            .sink { [weak self] condition in
                self?.updateWeatherConditions(for: condition)
            }
            .store(in: &cancellables)
    }
    
    private func updateWeatherData(for weather: WeatherDataModel?) {
        guard let weather = weather else {
            additionalWeatherConditions = []
            weatherRecommendations = []
            return
        }
        
        updateWeatherConditions(for: weather.condition)
        updateWeatherRecommendations(for: weather)
    }
    
    private func updateWeatherConditions(for condition: String) {
        additionalWeatherConditions = weatherService.additionalWeatherConditions(for: condition)
    }
    
    private func updateWeatherRecommendations(for weather: WeatherDataModel) {
        if let service = weatherService as? WeatherService {
            weatherRecommendations = service.weatherRecommendations(for: weather)
        }
    }
    
    // MARK: - Weather UI Helpers (delegando para o serviço)
    func weatherColor(for condition: String) -> Color {
        weatherService.weatherColor(for: condition)
    }
    
    func weatherIcon(for condition: String, isDay: Bool = true) -> String {
        if let service = weatherService as? WeatherService {
            return service.weatherIcon(for: condition, isDay: isDay)
        }
        return "questionmark.circle.fill"
    }
}
