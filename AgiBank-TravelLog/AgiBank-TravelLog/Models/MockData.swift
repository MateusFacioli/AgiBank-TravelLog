//
//  MockData.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import CoreLocation
import Foundation
import MapKit
import SwiftUI

// MARK: - Mocks Globais
public enum MockData {

    // MARK: - EnrichedDestinationData
    static let enrichedDestinationModel = EnrichedDestinationModel(
        destinationId: UUID(),
        weather: WeatherDataModel(
            temperature: 25.5,
            condition: "Ensolarado",
            icon: "sun.max.fill",
            humidity: 65,
            windSpeed: 15.2,
            feelsLike: 26.0,
            precipitation: 0,
            uvIndex: 7,
            lastUpdated: Date()
        ),
        photos: [ "https://images.unsplash.com/photo-1502602898457-c46ad927bd85",
            "https://images.unsplash.com/photo-1499856871958-5b9627545d1a",
            "https://images.unsplash.com/photo-1523531294919-4bcd7c65e216",
            "https://images.unsplash.com/photo-1528825871115-3581a5387919",
        ],
        localReviews: [
            LocalReviewModel(source: "Google Maps", rating: 4.5, reviewCount: 1200),
            LocalReviewModel(source: "TripAdvisor", rating: 4.7, reviewCount: 850),
            LocalReviewModel(source: "Viagens.com", rating: 4.8, reviewCount: 430),
        ],
        nearbyAttractions: ["praia, pier"],
        travelTime: TravelTimeDataModel(
            duration: "2h 30m",
            distance: "150 km",
            routeType: "Mais rápido"
        ),
        bestSeason: "Primavera (Março a Maio)",
        lastUpdated: Date()

    )

    static let enrichedDestinationDataWithoutWeather = EnrichedDestinationModel(
        destinationId: UUID(),
        weather: nil,
        photos: [
            "https://images.unsplash.com/photo-1483729558449-99ef09a8c325"
        ],
        localReviews: [],
        nearbyAttractions: ["teste, teste"],
        travelTime: TravelTimeDataModel(
            duration: "1h 45m",
            distance: "95 km",
            routeType: "Mais rápido"
        ),
        bestSeason: "Verão (Dezembro a Março)",
        lastUpdated: Date()
    )
    // MARK: - TransportOptionModel
    static let transportOptions: [TransportOptionModel] = [
        TransportOptionModel(
            name: "Uber X",
            type: .rideSharing,
            icon: "car.fill",
            color: .black,
            coordinate: CLLocationCoordinate2D(
                latitude: -23.5505,
                longitude: -46.6333
            ),
            duration: 8,
            distance: 3.2,
            price: "R$ 15-20",
            details: ["Chega em 5min", "4.8 ★"]
        ),
        TransportOptionModel(
            name: "99 Pop",
            type: .rideSharing,
            icon: "car.fill",
            color: .purple,
            coordinate: CLLocationCoordinate2D(
                latitude: -23.5512,
                longitude: -46.6328
            ),
            duration: 6,
            distance: 2.8,
            price: "R$ 13-17",
            details: ["Chega em 4min", "Economy"]
        ),
        TransportOptionModel(
            name: "Táxi Convencional",
            type: .taxi,
            icon: "taxi.fill",
            color: .yellow,
            coordinate: CLLocationCoordinate2D(
                latitude: -23.5498,
                longitude: -46.6342
            ),
            duration: 3,
            distance: 0.8,
            price: "R$ 12-15",
            details: ["Disponível agora", "Taxímetro"]
        ),
        TransportOptionModel(
            name: "Ônibus 701P",
            type: .bus,
            icon: "bus.fill",
            color: .green,
            coordinate: CLLocationCoordinate2D(
                latitude: -23.552,
                longitude: -46.635
            ),
            duration: 15,
            distance: 2.5,
            price: "R$ 4,40",
            details: ["Próximo em 5min", "Terminal Pinheiros"]
        ),
        TransportOptionModel(
            name: "Metrô Linha 4",
            type: .subway,
            icon: "tram.fill",
            color: .blue,
            coordinate: CLLocationCoordinate2D(
                latitude: -23.5535,
                longitude: -46.6365
            ),
            duration: 8,
            distance: 1.2,
            price: "R$ 4,40",
            details: ["Próximo em 3min", "Sentido Luz"]
        ),
        TransportOptionModel(
            name: "Bike Itaú",
            type: .bike,
            icon: "bicycle",
            color: .orange,
            coordinate: CLLocationCoordinate2D(
                latitude: -23.549,
                longitude: -46.632
            ),
            duration: 12,
            distance: 1.5,
            price: "R$ 5/hora",
            details: ["3 bikes disponíveis", "Estação Paulista"]
        ),
        TransportOptionModel(
            name: "Lime Scooter",
            type: .scooter,
            icon: "scooter",
            color: .green,
            coordinate: CLLocationCoordinate2D(
                latitude: -23.552,
                longitude: -46.635
            ),
            duration: 8,
            distance: 2.1,
            price: "R$ 3 + R$ 0.5/min",
            details: ["2 scooters próximos", "Bateria 80%"]
        ),
    ]

    static let transportSample: TransportOptionModel = transportOptions[0]

    // MARK: - TravelDestination
    static let travelDestination: TravelDestination = TravelDestination(
        id: UUID(),
        name: "Paris, França",
        location: "Europa",
        startDate: Date(),
        endDate: Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
        rating: 4.8,
        notes:
            "Conhecida como a Cidade Luz, Paris é famosa por sua arquitetura icônica, museus de classe mundial e culinária refinada.",
        photos: [
            "https://images.unsplash.com/photo-1502602898457-c46ad927bd85"
        ],
        category: .relax
    )

    static let travelDestinations: [TravelDestination] = [
        TravelDestination(
            id: UUID(),
            name: "Paris, França",
            location: "Europa",
            startDate: Date(),
            endDate: Calendar.current.date(
                byAdding: .day,
                value: 15,
                to: Date()
            )!,
            rating: 4.8,
            notes:
                "Conhecida como a Cidade Luz, Paris é famosa por sua arquitetura icônica, museus de classe mundial e culinária refinada.",
            photos: [
                "https://images.unsplash.com/photo-1502602898457-c46ad927bd85"
            ],
            category: .relax
        ),
        TravelDestination(
            id: UUID(),
            name: "Rio de Janeiro",
            location: "Brasil",
            startDate: Calendar.current.date(
                byAdding: .month,
                value: -1,
                to: Date()
            )!,
            endDate: Calendar.current.date(
                byAdding: .month,
                value: -1,
                to: Calendar.current.date(
                    byAdding: .day,
                    value: 10,
                    to: Date()
                )!
            )!,
            rating: 4.7,
            notes: "Cidade maravilhosa com praias famosas e o Cristo Redentor.",
            photos: [
                "https://images.unsplash.com/photo-1483729558449-99ef09a8c325"
            ],
            category: .adventure
        ),
        TravelDestination(
            id: UUID(),
            name: "Tóquio, Japão",
            location: "Ásia",
            startDate: Calendar.current.date(
                byAdding: .month,
                value: 2,
                to: Date()
            )!,
            endDate: Calendar.current.date(
                byAdding: .month,
                value: 2,
                to: Calendar.current.date(
                    byAdding: .day,
                    value: 14,
                    to: Date()
                )!
            )!,
            rating: 4.9,
            notes:
                "Metrópole vibrante combinando tradição e tecnologia de ponta.",
            photos: [
                "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf"
            ],
            category: .solo
        ),
        TravelDestination(
            id: UUID(),
            name: "Nova York, EUA",
            location: "América do Norte",
            startDate: Calendar.current.date(
                byAdding: .month,
                value: 3,
                to: Date()
            )!,
            endDate: Calendar.current.date(
                byAdding: .month,
                value: 3,
                to: Calendar.current.date(
                    byAdding: .day,
                    value: 10,
                    to: Date()
                )!
            )!,
            rating: 4.6,
            notes:
                "A cidade que nunca dorme, com arranha-céus icônicos e cultura vibrante.",
            photos: [
                "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9"
            ],
            category: .business
        ),
        TravelDestination(
            id: UUID(),
            name: "Orlando, EUA",
            location: "Flórida",
            startDate: Calendar.current.date(
                byAdding: .month,
                value: 4,
                to: Date()
            )!,
            endDate: Calendar.current.date(
                byAdding: .month,
                value: 4,
                to: Calendar.current.date(byAdding: .day, value: 7, to: Date())!
            )!,
            rating: 4.5,
            notes:
                "Capital mundial dos parques temáticos, ideal para viagens em família.",
            photos: [
                "https://images.unsplash.com/photo-1519904981063-b0cf448d479e"
            ],
            category: .family
        ),
    ]

    // MARK: - ViewModel Helpers
    @MainActor
    static func createTransportViewModel() -> TransportViewModel {
        let viewModel = TransportViewModel()
        viewModel.transportOptions = transportOptions
        viewModel.selectedTransportTypes = Set(TransportType.allCases)
        viewModel.userLocation = CLLocation(
            latitude: -23.5505,
            longitude: -46.6333
        )
        return viewModel
    }
}
