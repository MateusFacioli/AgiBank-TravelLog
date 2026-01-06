//
//  TransportAPIService.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import Foundation
import SwiftUI
import CoreLocation

/// Serviço que agrega múltiplas fontes externas para enriquecer dados de destinos.
///
/// Faz caching, chamadas paralelas e fallback para dados mock quando chaves de API
/// não estão configuradas.
protocol TransportAPIServiceProtocol {
    func enrichDestination(_ destination: TravelDestination) async throws -> EnrichedDestinationModel
    func getCachedData(for key: String) -> EnrichedDestinationModel?
    func cacheData(_ data: EnrichedDestinationModel, for key: String)
}

class TransportAPIService: TransportAPIServiceProtocol {
    static let shared = TransportAPIService()
    
    private let cache = NSCache<NSString, CachedDestinationData>()
    private let session = URLSession.shared
    private let cacheTTL: TimeInterval = 3600 // 1 hora
    
    private init() {}
    
    // MARK: - Public API
    
    /// Enriquecimento principal: agrupa clima, fotos, avaliações, tempo de viagem etc.
    /// - Parameter destination: destino a ser enriquecido.
    /// - Returns: `EnrichedDestinationModel` com os dados agregados.
    func enrichDestination(_ destination: TravelDestination) async throws -> EnrichedDestinationModel {
        // Verifica cache primeiro
        let cacheKey = destination.id.uuidString
        if let cached = getCachedData(for: cacheKey),
           Date().timeIntervalSince(cached.lastUpdated) < cacheTTL {
            return cached
        }
        
        // Busca dados em paralelo
        var enrichedData = EnrichedDestinationModel(
            destinationId: destination.id,
            weather: nil,
            photos: [],
            localReviews: [LocalReviewModel(source: "", rating: 4.5, reviewCount: 45)],
           
            nearbyAttractions: ["",""],
            travelTime: nil,
            bestSeason: "",
            lastUpdated: Date()
        )
        
        await withTaskGroup(of: Void.self) { group in
            // 1. Clima atual
            group.addTask {
                if let weather = await self.fetchWeather(for: destination.location) {
                    enrichedData.weather = weather
                }
            }
            
            // 2. Fotos reais do local
            group.addTask {
                if let photos = await self.fetchDestinationPhotos(for: destination.name) {
                    enrichedData.photos = photos
                }
            }
            
            // 3. Avaliações locais
            group.addTask {
                if let reviews = await self.fetchLocalReviews(for: destination.name,
                                                            location: destination.location) {
                    enrichedData.localReviews = reviews
                }
            }
            
            // 4. Tempo de viagem da localização atual
            group.addTask {
                if let travelTime = await self.calculateTravelTime(to: destination.location) {
                    enrichedData.travelTime = travelTime
                }
            }
            
            // 5. Melhor época para visitar
            group.addTask {
                enrichedData.bestSeason = self.calculateBestSeason(for: destination.location)
            }
        }
        
        // Atualiza cache
        cacheData(enrichedData, for: cacheKey)
        
        return enrichedData
    }
    
    /// Retorna dados em cache (se existirem).
    func getCachedData(for key: String) -> EnrichedDestinationModel? {
        return cache.object(forKey: key as NSString)?.data
    }
    
    /// Armazena dados no cache.
    func cacheData(_ data: EnrichedDestinationModel, for key: String) {
        cache.setObject(
            CachedDestinationData(data: data),
            forKey: key as NSString
        )
    }
    
    // MARK: - APIs Reais (implementações auxiliares)
    
    private func fetchWeather(for location: String) async -> WeatherDataModel? {
        guard let apiKey = Bundle.main.infoDictionary?["OpenWeatherAPIKey"] as? String else {
            print("⚠️ OpenWeather API Key não configurada - usando dados mockados")
            return mockWeatherDataModel(for: location)
        }
        
        let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedLocation)&appid=\(apiKey)&units=metric&lang=pt_br"
        
        guard let url = URL(string: urlString) else {
            return mockWeatherDataModel(for: location)
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("❌ Resposta inválida da API do clima")
                return mockWeatherDataModel(for: location)
            }
            
            let weatherResponse = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
            
            return WeatherDataModel(
                temperature: weatherResponse.main.temp,
                condition: weatherResponse.weather.first?.description.capitalized ?? "Desconhecido",
                icon: weatherIcon(for: weatherResponse.weather.first?.id ?? 0),
                humidity: Double(weatherResponse.main.humidity),
                windSpeed: weatherResponse.wind.speed,
                feelsLike: weatherResponse.main.feels_like,
                precipitation: Double(weatherResponse.clouds.all) / 100.0, // Aproximação
                uvIndex: nil,
                lastUpdated: Date()
            )
        } catch {
            print("❌ Erro ao buscar clima: \(error)")
            return mockWeatherDataModel(for: location)
        }
    }
    
    private func fetchDestinationPhotos(for destination: String) async -> [String]? {
        guard let apiKey = Bundle.main.infoDictionary?["UnsplashAPIKey"] as? String else {
            print("⚠️ Unsplash API Key não configurada")
            return nil
        }
        
        let encodedQuery = destination.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.unsplash.com/search/photos?query=\(encodedQuery)&per_page=5&client_id=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("❌ Resposta inválida da Unsplash API")
                return nil
            }
            
            let unsplashResponse = try JSONDecoder().decode(UnsplashResponse.self, from: data)
            
            return unsplashResponse.results.map { $0.urls.regular }
        } catch {
            print("❌ Erro ao buscar fotos: \(error)")
            return nil
        }
    }
    
    private func fetchLocalReviews(for place: String, location: String) async -> [LocalReviewModel]? {
        guard let apiKey = Bundle.main.infoDictionary?["GoogleAPIKey"] as? String else {
            print("⚠️ Google API Key não configurada")
            return mockLocalReviews()
        }
        
        let encodedQuery = "\(place) \(location)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(encodedQuery)&key=\(apiKey)&language=pt-BR"
        
        guard let url = URL(string: urlString) else { return mockLocalReviews() }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("❌ Resposta inválida do Google Places")
                return mockLocalReviews()
            }
            
            let placesResponse = try JSONDecoder().decode(GooglePlacesResponse.self, from: data)
            
            return placesResponse.results.compactMap { result in
                guard let rating = result.rating else { return nil }
                return LocalReviewModel(
                    source: "Google Places",
                    rating: rating,
                    reviewCount: result.user_ratings_total ?? 0
                )
            }
        } catch {
            print("❌ Erro ao buscar avaliações: \(error)")
            return mockLocalReviews()
        }
    }
    
    private func calculateTravelTime(to destination: String) async -> TravelTimeDataModel? {
        guard let destinationCoord = await geocodeAddress(destination) else {
            return mockTravelTimeData()
        }
        
        // Para produção, você obteria a localização atual do usuário
        // Aqui usamos uma localização fixa para exemplo
        guard let userLocation = await getCurrentLocation() else {
            return mockTravelTimeData()
        }
        
        guard let apiKey = Bundle.main.infoDictionary?["GoogleAPIKey"] as? String else {
            return mockTravelTimeData()
        }
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?" +
        "origin=\(userLocation.latitude),\(userLocation.longitude)" +
        "&destination=\(destinationCoord.latitude),\(destinationCoord.longitude)" +
        "&mode=driving&key=\(apiKey)&language=pt-BR"
        
        guard let url = URL(string: urlString) else { return mockTravelTimeData() }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("❌ Resposta inválida do Google Directions")
                return mockTravelTimeData()
            }
            
            let directionsResponse = try JSONDecoder().decode(MapsDirectionResponse.self, from: data)
            
            guard let route = directionsResponse.routes.first,
                  let leg = route.legs.first else {
                return mockTravelTimeData()
            }
            
            return TravelTimeDataModel(
                duration: leg.duration.text,
                distance: leg.distance.text,
                routeType: "Mais rápido"
            )
        } catch {
            print("❌ Erro ao calcular tempo de viagem: \(error)")
            return mockTravelTimeData()
        }
    }
    
    // MARK: - Helper Methods
    
    private func weatherIcon(for code: Int) -> String {
        switch code {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "cloud.fog.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.fill"
        default: return "questionmark.circle.fill"
        }
    }
    
    private func geocodeAddress(_ address: String) async -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            return placemarks.first?.location?.coordinate
        } catch {
            print("❌ Erro no geocoding: \(error)")
            return nil
        }
    }
    
    private func getCurrentLocation() async -> CLLocationCoordinate2D? {
        // Em produção, use CLLocationManager para obter localização real
        // Aqui retornamos uma localização fixa (São Paulo) para exemplo
        return CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
    }
    
    private func calculateBestSeason(for location: String) -> String {
        let lowerLocation = location.lowercased()
        
        if lowerLocation.contains("europa") || lowerLocation.contains("eua") ||
           lowerLocation.contains("canadá") {
            return "Primavera/Verão (Abr-Set)"
        } else if lowerLocation.contains("áfrica") || lowerLocation.contains("austrália") {
            return "Inverno local (Jun-Ago)"
        } else if lowerLocation.contains("ásia") {
            return "Outono/Primavera"
        } else if lowerLocation.contains("praia") || lowerLocation.contains("litoral") {
            return "Verão (Dez-Mar)"
        } else {
            return "Ano todo"
        }
    }
    
    // MARK: - Fallback Data (para quando APIs falham)
    
    private func mockWeatherDataModel(for location: String) -> WeatherDataModel {
        // Gera dados consistentes baseados na localização
        let hash = abs(location.hash)
        let temperature = 15.0 + Double(hash % 25) // 15-40°C
        let humidity = 30.0 + Double(hash % 50) // 30-80%
        
        let conditions = ["Ensolarado", "Parcialmente nublado", "Nublado", "Chuva leve", "Tempestade"]
        let condition = conditions[hash % conditions.count]
        
        return WeatherDataModel(
            temperature: temperature,
            condition: condition,
            icon: weatherIcon(for: condition),
            humidity: humidity,
            windSpeed: 5.0 + Double(hash % 15),
            feelsLike: temperature + 2.0,
            precipitation: Double(hash % 100) / 100.0,
            uvIndex: Double(hash % 11),
            lastUpdated: Date()
        )
    }
    
    private func weatherIcon(for condition: String) -> String {
        let lowerCondition = condition.lowercased()
        
        if lowerCondition.contains("sol") || lowerCondition.contains("ensolarado") {
            return "sun.max.fill"
        } else if lowerCondition.contains("nublado") {
            return "cloud.fill"
        } else if lowerCondition.contains("chuva") {
            return "cloud.rain.fill"
        } else if lowerCondition.contains("tempestade") {
            return "cloud.bolt.fill"
        } else if lowerCondition.contains("neve") {
            return "cloud.snow.fill"
        } else {
            return "cloud.fill"
        }
    }
    
    private func mockLocalReviews() -> [LocalReviewModel] {
        return [
            LocalReviewModel(source: "Google Maps", rating: 4.5, reviewCount: 1200),
            LocalReviewModel(source: "TripAdvisor", rating: 4.7, reviewCount: 850)
        ]
    }
    
    private func mockTravelTimeData() -> TravelTimeDataModel {
        return TravelTimeDataModel(
            duration: "2h 30m",
            distance: "150 km",
            routeType: "Mais rápido"
        )
    }
}

// MARK: - API Response Models

private struct OpenWeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let humidity: Int
    }
    
    struct Weather: Codable {
        let id: Int
        let description: String
    }
    
    struct Wind: Codable {
        let speed: Double
    }
    
    struct Clouds: Codable {
        let all: Int // cobertura de nuvens em %
    }
}

private struct UnsplashResponse: Codable {
    let results: [UnsplashPhoto]
    
    struct UnsplashPhoto: Codable {
        let urls: PhotoURLs
        
        struct PhotoURLs: Codable {
            let regular: String
        }
    }
}

private struct GooglePlacesResponse: Codable {
    let results: [Place]
    
    struct Place: Codable {
        let name: String
        let rating: Double?
        let user_ratings_total: Int?
    }
}

// MARK: - Cache Model

class CachedDestinationData: NSObject {
    let data: EnrichedDestinationModel
    
    init(data: EnrichedDestinationModel) {
        self.data = data
    }
}
