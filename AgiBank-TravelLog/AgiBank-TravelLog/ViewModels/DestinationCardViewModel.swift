//
//  DestinationCardViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import SwiftUI
import Combine
import UIKit

/**
 Marca a classe para que todas as operações sejam executadas na Main Thread (thread principal).
 Isso garante que todas as atualizações de estado e UI estejam protegidas contra race conditions,
 essencial em ViewModels que lidam com SwiftUI.
 */
@MainActor
final class DestinationCardViewModel: ObservableObject {
    /// Avaliação atual exibida no cartão do destino.
    /// Usando @Published pois permite que SwiftUI atualize a interface automaticamente quando o valor muda.
    @Published var currentRating: Float
    /// Dados enriquecidos sobre o destino (clima, tempo de viagem, etc).
    @Published var enrichedData: EnrichedDestinationModel?
    /// Indica se o enriquecimento dos dados está em andamento.
    @Published var isLoadingEnrichment = false
    /// Índice da foto selecionada para exibição.
    @Published var selectedPhotoIndex = 0
    /// Condições climáticas adicionais calculadas para exibir no cartão.
    @Published var additionalWeatherConditions: [AdditionalWeatherCondition] = []
    /// Recomendações baseadas no clima atual.
    @Published var weatherRecommendations: [WeatherRecommendation] = []
    /// Indica se o destino está marcado como favorito.
    @Published var isFavorited: Bool = false
    
    /// A propriedade é private para garantir o encapsulamento e que só a própria ViewModel possa alterar esse valor.
    /// Destino de viagem que esta ViewModel representa.
    private let destination: TravelDestination
    /// Serviço para realizar chamadas à API de transporte.
    private let apiService: TransportAPIServiceProtocol
    /// Serviço para obter dados e lógica relacionados ao clima.
    private let weatherService: WeatherServiceProtocol
    /// Conjunto para armazenar assinaturas Combine.
    private var cancellables = Set<AnyCancellable>()
    
    /// Serviço usado para persistir e consultar favoritos.
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
    /// Carrega e atualiza dados enriquecidos para o destino, incluindo clima e tempo de viagem.
    /// Atualiza propriedades relacionadas ao clima e recomendações.
    /// Deve ser chamado de forma assíncrona.
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
    /// Alterna o status de favorito do destino, salvando ou removendo dos favoritos persistidos.
    /// Dispara feedback háptico ao adicionar aos favoritos.
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
    /// Prepara uma lista de itens para compartilhamento do destino, incluindo notas e clima se disponível.
    func shareDestination() -> [Any] {
        print("🔍 shareDestination() chamado - enrichedData existe? \(enrichedData != nil)")
        print("🔍 Clima existe? \(enrichedData?.weather != nil)")
        return prepareShareItems()
    }

    /// Prepara uma mensagem de texto para compartilhar o destino junto com as informações de clima.
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
    /// O uso de private nessa função garante que apenas a própria ViewModel pode gerenciar esta lógica de atualização.
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
    /// Retorna a cor UI adequada para a condição climática informada.
    /// - Parameter condition: String representando a condição do clima.
    /// - Returns: Cor apropriada para exibição.
    func weatherColor(for condition: String) -> Color {
        weatherService.weatherColor(for: condition)
    }
    
    /// Retorna o nome do ícone SF Symbol correspondente à condição climática.
    /// - Parameters:
    ///   - condition: Condição do clima
    ///   - isDay: Booleano indicando se é dia
    /// - Returns: Nome do símbolo para exibição
    func weatherIcon(for condition: String, isDay: Bool = true) -> String {
        if let service = weatherService as? WeatherService {
            return service.weatherIcon(for: condition, isDay: isDay)
        }
        return "questionmark.circle.fill"
    }
}

