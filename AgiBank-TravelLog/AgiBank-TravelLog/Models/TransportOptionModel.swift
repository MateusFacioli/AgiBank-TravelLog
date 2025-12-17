//
//  TransportOptionModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import Combine

// MARK: - Data Models
struct TransportOptionModel: Identifiable, Equatable {
   
    let id = UUID()
    let name: String
    let type: TransportType
    let icon: String
    let color: Color
    var coordinate: CLLocationCoordinate2D
    let duration: Int // minutos
    let distance: Double // km
    let price: String?
    let details: [String]
    
    static func == (lhs: TransportOptionModel, rhs: TransportOptionModel) -> Bool {
        lhs.id == rhs.id
    }
}

enum TransportType: String, CaseIterable, Identifiable {
    case rideSharing = "App de Transporte"
    case taxi = "Táxi"
    case bus = "Ônibus"
    case subway = "Metrô"
    case bike = "Bicicleta"
    case scooter = "Patinete"
    case publicTransport = "Transporte Público"
    case ferry = "Balsa"
    case train = "Trem"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .rideSharing: return "car.fill"
        case .taxi: return "taxi.fill"
        case .bus: return "bus.fill"
        case .subway: return "tram.fill"
        case .bike: return "bicycle"
        case .scooter: return "scooter"
        case .publicTransport: return "bus.fill"
        case .ferry: return "ferry.fill"
        case .train: return "train.side.front.car"
        }
    }
    
    var color: Color {
        switch self {
        case .rideSharing: return .black
        case .taxi: return .yellow
        case .bus: return .green
        case .subway: return .blue
        case .bike: return .orange
        case .scooter: return .green
        case .publicTransport: return .purple
        case .ferry: return .cyan
        case .train: return .red
        }
    }
}
