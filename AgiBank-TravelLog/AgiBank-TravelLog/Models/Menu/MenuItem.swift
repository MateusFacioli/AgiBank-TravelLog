//
//  MenuItem.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import Foundation
import SwiftUI

struct MenuItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let icon: String
    let category: MenuCategory
    var isSelected: Bool = false
    
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.id == rhs.id
    }
    
    static func from(category: MenuCategory, isSelected: Bool = false) -> MenuItem {
        return MenuItem(
            title: category.title,
            icon: category.icon,
            category: category,
            isSelected: isSelected
        )
    }
}

// MARK: - MenuCategory Enum
extension MenuItem {
    enum MenuCategory: String, CaseIterable {
        case myTrips = "Minhas Viagens"
        case flights = "Voos"
        case hotels = "Hotéis"
        case ubers = "Transporte"
        case cruises = "Cruzeiros"
        case camping = "Camping"
        case adventures = "Aventuras"
        case restaurants = "Restaurantes"
        case shopping = "Compras"
        case activities = "Atividades"
        
        var icon: String {
            switch self {
            case .myTrips: return "suitcase.fill"
            case .flights: return "airplane"
            case .hotels: return "building.fill"
            case .ubers: return "car.fill"
            case .cruises: return "ferry.fill"
            case .camping: return "tent.fill"
            case .adventures: return "mountain.2.fill"
            case .restaurants: return "fork.knife"
            case .shopping: return "bag.fill"
            case .activities: return "figure.play"
            }
        }
        
        var title: String {
            return self.rawValue
        }
        
        var emptyStateTitle: String {
            switch self {
            case .myTrips: return "Nenhuma Viagem Encontrada"
            default: return "Nenhum \(self.rawValue) Encontrado"
            }
        }
        
        var emptyStateMessage: String {
            switch self {
            case .myTrips: return "Comece adicionando sua primeira viagem para ver seus destinos aqui."
            case .flights: return "Adicione voos ao planejar suas viagens."
            case .hotels: return "Registre suas reservas de hotel para ter tudo organizado."
            case .ubers: return "Mantenha o controle de seus transportes durante as viagens."
            case .cruises: return "Planeje seus cruzeiros e aventuras marítimas."
            case .camping: return "Organize suas aventuras ao ar livre."
            case .adventures: return "Registre suas aventuras emocionantes."
            case .restaurants: return "Salve os restaurantes que deseja visitar."
            case .shopping: return "Mantenha uma lista de compras durante suas viagens."
            case .activities: return "Planeje atividades para suas viagens."
            }
        }
        
        var keywords: [String] {
            switch self {
            case .myTrips: return ["viagens", "destinos", "lugares", "roteiros"]
            case .flights: return ["voos", "aéreo", "avião", "aeroporto"]
            case .hotels: return ["hotéis", "hospedagem", "acomodação", "pousada"]
            case .ubers: return ["transporte", "táxi", "carro", "uber", "locomoção"]
            case .cruises: return ["cruzeiros", "navio", "marítimo", "oceano"]
            case .camping: return ["camping", "acampamento", "natureza", "barraca"]
            case .adventures: return ["aventuras", "radical", "esportes", "emoção"]
            case .restaurants: return ["restaurantes", "comida", "gastronomia", "culinária"]
            case .shopping: return ["compras", "lojas", "shopping", "mercado"]
            case .activities: return ["atividades", "passeios", "programação", "diversão"]
            }
        }
        
        // Para analytics/tracking
        var analyticsName: String {
            return "menu_category_\(self.rawValue.lowercased().replacingOccurrences(of: " ", with: "_"))"
        }
    }
}

// MARK: - Convenience Methods
extension MenuItem {
    // Retorna todos os itens do menu em ordem
    static var allItems: [MenuItem] {
        return MenuCategory.allCases.map { MenuItem.from(category: $0) }
    }
    
    // Retorna itens pré-selecionados (para uso inicial)
    static var defaultItems: [MenuItem] {
        return MenuCategory.allCases.map {
            MenuItem.from(category: $0, isSelected: $0 == .myTrips)
        }
    }
    
    // Factory method para criar um menu com um item específico selecionado
    static func menuWithSelected(_ selectedCategory: MenuCategory) -> [MenuItem] {
        return MenuCategory.allCases.map {
            MenuItem.from(
                category: $0,
                isSelected: $0 == selectedCategory
            )
        }
    }
}

// MARK: - Helper Functions
extension MenuItem {
    // Verifica se a categoria representa uma viagem principal
    var isMainTripCategory: Bool {
        return category == .myTrips
    }
    
    // Verifica se a categoria representa uma reserva/acomodação
    var isAccommodationCategory: Bool {
        return [.hotels, .camping].contains(category)
    }
    
    // Verifica se a categoria representa transporte
    var isTransportCategory: Bool {
        return [.flights, .ubers, .cruises].contains(category)
    }
    
    // Verifica se a categoria representa atividades/lazer
    var isActivityCategory: Bool {
        return [.adventures, .restaurants, .shopping, .activities].contains(category)
    }
}


// MARK: - Codable Support (se necessário para persistência)
extension MenuItem: Codable {
    enum CodingKeys: String, CodingKey {
        case title, icon, category, isSelected
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        icon = try container.decode(String.self, forKey: .icon)
        let categoryString = try container.decode(String.self, forKey: .category)
        category = MenuCategory(rawValue: categoryString) ?? .myTrips
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(icon, forKey: .icon)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(isSelected, forKey: .isSelected)
    }
}
