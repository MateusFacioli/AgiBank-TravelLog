//
//  TransportViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 15/12/25.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import Combine

@MainActor
class TransportViewModel: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var userLocation: CLLocation?
    @Published var searchRadius: Double = 5.0 // km
    @Published var transportOptions: [TransportOptionModel] = []
    @Published var isLoading = false
    @Published var showLocationAlert = false
    @Published var selectedTransportTypes: Set<TransportType>
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333), // São Paulo
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
//    private var apiService = TransportAPIService()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    override init() {
        self.selectedTransportTypes = Set(TransportType.allCases)
        super.init()
        setupLocationManager()
        setupSubscriptions()
    }
    
    // MARK: - Setup Methods
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupSubscriptions() {
        $userLocation
            .compactMap { $0 }
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] location in
                self?.region.center = location.coordinate
                self?.searchTransportOptions()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showLocationAlert = true
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func centerOnUserLocation() {
        guard let location = userLocation else {
            requestLocationPermission()
            return
        }
        
        withAnimation(.spring()) {
            region.center = location.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        }
    }
    
    func searchTransportOptions() {
        guard let userLocation = userLocation else {
            requestLocationPermission()
            return
        }
        
        isLoading = true
        
        Task {
            do {
                // Busca opções de transporte (simulado + APIs reais)
                let options = try await fetchTransportOptions(
                    from: userLocation.coordinate,
                    radius: searchRadius * 1000 // converter para metros
                )
                
                // Filtra pelos tipos selecionados
                let filteredOptions = options.filter { option in
                    selectedTransportTypes.contains(option.type)
                }
                
                await MainActor.run {
                    self.transportOptions = filteredOptions
                    self.isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    self.transportOptions = MockData.transportOptions
                    self.isLoading = false
                }
                print("Erro ao buscar transportes: \(error)")
            }
        }
    }
    
    func searchForLocation(_ query: String) {
        // MARK: TODO Implementar busca por endereço usando CLGeocoder ou Google Places API
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(query) { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first else { return }
            
            if let location = placemark.location {
                Task { @MainActor in
                    withAnimation {
                        self.region.center = location.coordinate
                        self.userLocation = location
                    }
                }
            }
        }
    }
    
    // MARK: - API Integration
    private func fetchTransportOptions(
        from coordinate: CLLocationCoordinate2D,
        radius: Double
    ) async throws -> [TransportOptionModel] {
        // Aqui você integra com APIs reais
        
        var allOptions: [TransportOptionModel] = []
        
        // 1. Dados mockados para desenvolvimento
        allOptions.append(contentsOf: MockData.transportOptions)
        
        // 2. Google Directions API (se tiver API Key)
        if let googleOptions = try? await fetchGoogleTransportOptions(
            from: coordinate,
            radius: radius
        ) {
            allOptions.append(contentsOf: googleOptions)
        }
        
        // 3. API de transporte público (ex: SPTrans para São Paulo)
        if let publicTransport = try? await fetchPublicTransportOptions(
            from: coordinate
        ) {
            allOptions.append(contentsOf: publicTransport)
        }
        
        // Ordena por tempo
        return allOptions.sorted { $0.duration < $1.duration }
    }
    
    private func fetchGoogleTransportOptions(
        from coordinate: CLLocationCoordinate2D,
        radius: Double
    ) async throws -> [TransportOptionModel] {
        // Implementação com Google Directions API
        // Você precisará de uma API Key do Google Cloud Platform
        
        guard let apiKey = Bundle.main.infoDictionary?["GOOGLE_API_KEY"] as? String else {
            return []
        }
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?" +
        "origin=\(coordinate.latitude),\(coordinate.longitude)" +
        "&destination=\(coordinate.latitude + 0.01),\(coordinate.longitude + 0.01)" +
        "&mode=transit" +
        "&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MapsDirectionResponse.self, from: data)
        
        return response.routes.compactMap { route -> TransportOptionModel? in
            guard let leg = route.legs.first else { return nil }
            
            return TransportOptionModel(
                name: "Transporte Google",
                type: TransportType.publicTransport,
                icon: "tram.fill",
                color: Color.blue,
                coordinate: coordinate,
                duration: leg.duration.value / 60, // converter para minutos
                distance: Double(leg.distance.value / 1000), // converter para km
                price: "",
                details: leg.steps.map { $0.instructions }
            )
        }
    }
    
    private func fetchPublicTransportOptions(
        from coordinate: CLLocationCoordinate2D
    ) async throws -> [TransportOptionModel] {
        // Exemplo: API da SPTrans (São Paulo)
        // Substitua pela API da sua cidade
        
        let urlString = "https://api.olhovivo.sptrans.com.br/v2.1/Posicao"
        
        guard URL(string: urlString) != nil else {
            return []
        }
        
        // Nota: A SPTrans requer autenticação
        // Esta é uma implementação simplificada
        
        return [
            TransportOptionModel(
                name: "Ônibus 701P",
                type: TransportType.bus,
                icon: "bus.fill",
                color: Color.green,
                coordinate: coordinate,
                duration: 15,
                distance: 2.5,
                price: "R$ 4,40",
                details: ["Próximo em 5min", "Terminal Pinheiros"]
            ),
            TransportOptionModel(
                name: "Linha 4-Amarela",
                type: TransportType.subway,
                icon: "tram.fill",
                color: Color.yellow,
                coordinate: coordinate,
                duration: 8,
                distance: 1.2,
                price: "R$ 4,40",
                details: ["Próximo em 3min", "Sentido Luz"]
            )
        ]
    }
    
    func updateSelectedTransportTypes(_ newSet: Set<TransportType>) {
        selectedTransportTypes = newSet
        searchTransportOptions()
    }
}

// MARK: - CLLocationManagerDelegate
extension TransportViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationAlert = true
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if userLocation == nil {
            // Primeira vez que obtém a localização
            region.center = location.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        }
        
        userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro no location manager: \(error)")
    }
}

// MARK: - Métodos para gerenciar tipos de transporte
extension TransportViewModel {
    func updateTransportType(_ type: TransportType, isSelected: Bool) {
        var updatedSet = selectedTransportTypes
        
        if isSelected {
            updatedSet.insert(type)
        } else {
            updatedSet.remove(type)
        }
        
        updateSelectedTransportTypes(updatedSet)
    }
    
    func resetTransportTypes() {
        updateSelectedTransportTypes(Set(TransportType.allCases))
    }
}
