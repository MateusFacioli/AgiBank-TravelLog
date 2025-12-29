//
//  DestinationCardViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//


import SwiftUI
import Combine
import UIKit

@MainActor
final class DestinationCardViewModel: ObservableObject {
    @Published var currentRating: Float
    @Published var enrichedData: EnrichedDestinationModel?
    @Published var isLoadingEnrichment = false
    @Published var selectedPhotoIndex = 0
    @Published var additionalWeatherConditions: [AdditionalWeatherCondition] = []
    @Published var weatherRecommendations: [WeatherRecommendation] = []
    @Published var isFavorited: Bool = false
    
    private let destination: TravelDestination
    private let apiService: TransportAPIServiceProtocol
    private let weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Serviço de persistência
    private let favoritesService = FavoritesService.shared
    
    init(
        destination: TravelDestination,
        apiService: TransportAPIServiceProtocol = TransportAPIService.shared,
        weatherService: WeatherServiceProtocol = WeatherService()
    ) {
        self.destination = destination
        self.apiService = apiService
        self.weatherService = weatherService
        self.currentRating = destination.rating
        
        self.isFavorited = favoritesService.isFavorite(destinationId: destination.id)
        
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
    
    // MARK: - Favorite Functions
    func toggleFavorite() {
        isFavorited.toggle()
        
        if isFavorited {
            favoritesService.addFavorite(destinationId: destination.id)
            
            // Feedback haptic
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } else {
            favoritesService.removeFavorite(destinationId: destination.id)
        }
        
        // Anima o coração
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            objectWillChange.send()
        }
    }
    
    func getFavoriteAction() -> (() -> Void) {
        return { [weak self] in
            self?.toggleFavorite()
        }
    }
    
    // MARK: - Share Functions
    func shareDestination() -> [Any] {
        print("🔍 shareDestination() chamado - enrichedData existe? \(enrichedData != nil)")
        print("🔍 Clima existe? \(enrichedData?.weather != nil)")
        return prepareShareItems()
    }

    func shareWithWeather() -> String? {
        print("🌤️ shareWithWeather() chamado")
        print("🌤️ enrichedData existe? \(enrichedData != nil)")
        print("🌤️ Weather existe? \(enrichedData?.weather != nil)")
        
        guard let weather = enrichedData?.weather else {
            print("❌ Clima não encontrado")
            return nil
        }
        
        let message = prepareWeatherShareMessage(weather: weather)
        print("✅ Mensagem gerada: \(message)")
        return message
    }
    
    func getShareAction() -> (() -> Void) {
        return { [weak self] in
            self?.shareDestination()
        }
    }
    
    func getShareWithWeatherAction() -> (() -> Void) {
        return { [weak self] in
            self?.shareWithWeather()
        }
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
    
    private func prepareShareItems() -> [Any] {
        var items: [Any] = ["🎯 \(destination.name)"]
        
        if let enrichedData = enrichedData {
            if let weather = enrichedData.weather {
                items.append("\n🌤️ Clima: \(weather.temperature)°C - \(weather.condition)")
            }
            if let travelTime = enrichedData.travelTime {
                items.append("\n🚗 Tempo de viagem: \(travelTime.duration)")
            }
        }
        
        items.append("\n⭐ Minha avaliação: \(String(format: "%.1f", currentRating))/5.0")
        items.append("\n✍️ Minhas notas: \(destination.notes)")
        items.append("\n📍 Local: \(destination.location)")
        items.append("\n📱 Compartilhado via AgiBank Travel Log")
        print("📦 prepareShareItems() retornou: \(items)")
        
        return items
    }
    
    private func prepareWeatherShareMessage(weather: WeatherDataModel) -> String {
        let message = """
        🌍 Destino: \(destination.name)
        📍 Local: \(destination.location)
        
        🌤️ Condições atuais:
        • Temperatura: \(weather.temperature)°C
        • Condição: \(weather.condition)
        • Umidade: \(weather.humidity)%
        • Vento: \(weather.windSpeed) km/h
        
        ⭐ Minha avaliação: \(String(format: "%.1f", currentRating))/5.0
        
        📱 Compartilhado via AgiBank Travel Log
        """
        print("🌤️ prepareWeatherShareMessage() retornou: \(message)")
        return message
    }
    
    private func presentShareSheet(items: [Any]) {
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Configura para iPad
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            
            // No iPad, precisa de sourceView
            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.sourceView = rootVC.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(
                    x: rootVC.view.bounds.midX,
                    y: rootVC.view.bounds.midY,
                    width: 0,
                    height: 0
                )
            }
            
            rootVC.present(activityVC, animated: true)
        }
    }
    
    // MARK: - Weather UI Helpers
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
