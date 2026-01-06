//
//  MenuItem.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import Foundation
import SwiftUI

/**
 Estrutura que representa um item de menu navegável no app.
 Contém título, ícone, categoria e estado de seleção associados a uma categoria de viagem.
 Usada para compor o menu principal de navegação de destinos, transportes e experiências.
 */
struct MenuItem: Identifiable, Equatable {
    /// Identificador único do item de menu.
    let id = UUID()
    /// Título visível para o usuário no menu.
    let title: String
    /// Nome do ícone associado ao item de menu.
    let icon: String
    /// Categoria do menu a que este item pertence.
    let category: MenuCategory
    /// Estado que indica se o item está atualmente selecionado no menu.
    var isSelected: Bool = false
    
    /// Verifica a igualdade entre dois itens de menu baseada no seu identificador único.
    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Cria um MenuItem a partir de uma categoria, podendo definir se está selecionado.
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

/**
 Enum que representa as diferentes categorias disponíveis no menu principal do app.
 Cada categoria corresponde a um tipo de destino, transporte ou atividade que o usuário pode acessar.
 */
extension MenuItem {
    enum MenuCategory: String, CaseIterable {
        /// Representa a categoria de viagens do usuário.
        case myTrips = "Minhas Viagens"
        /// Representa a categoria de voos do usuário.
        case flights = "Voos"
        /// Representa a categoria de hospedagens em hotéis.
        case hotels = "Hotéis"
        /// Representa a categoria de transportes terrestres (ex.: Uber).
        case ubers = "Transporte"
        /// Representa a categoria de cruzeiros marítimos.
        case cruises = "Cruzeiros"
        /// Representa a categoria de camping e acampamentos.
        case camping = "Camping"
        /// Representa a categoria de aventuras e esportes radicais.
        case adventures = "Aventuras"
        /// Representa a categoria de restaurantes para refeições.
        case restaurants = "Restaurantes"
        /// Representa a categoria de compras e lojas.
        case shopping = "Compras"
        /// Representa a categoria de atividades e passeios.
        case activities = "Atividades"
        
        /// Ícone associado visualmente a cada categoria.
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
        
        /// Título descritivo da categoria para exibição no menu.
        var title: String {
            return self.rawValue
        }
        
        /// Título para estados vazios (sem itens) personalizados por categoria.
        var emptyStateTitle: String {
            switch self {
            case .myTrips: return "Nenhuma Viagem Encontrada"
            default: return "Nenhum \(self.rawValue) Encontrado"
            }
        }
        
        /// Mensagem explicativa para estados vazios, orientando o usuário.
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
        
        /// Palavras-chave associadas para facilitar buscas e filtros.
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
        
        /// Nome utilizado para analytics e tracking, formatado para consistência.
        var analyticsName: String {
            return "menu_category_\(self.rawValue.lowercased().replacingOccurrences(of: " ", with: "_"))"
        }
    }
}

// MARK: - Convenience Methods
extension MenuItem {
    /// Retorna todos os itens do menu em ordem padrão, com isSelected = false.
    static var allItems: [MenuItem] {
        return MenuCategory.allCases.map { MenuItem.from(category: $0) }
    }
    
    /// Retorna os itens padrão do menu, com a categoria `.myTrips` selecionada.
    static var defaultItems: [MenuItem] {
        return MenuCategory.allCases.map {
            MenuItem.from(category: $0, isSelected: $0 == .myTrips)
        }
    }
    
    /// Factory method para criar um menu com um item específico selecionado.
    /// - Parameter selectedCategory: Categoria que será marcada como selecionada.
    /// - Returns: Array de MenuItem com somente a categoria selecionada marcada.
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
    /// Verifica se a categoria representa uma viagem principal.
    var isMainTripCategory: Bool {
        return category == .myTrips
    }
    
    /// Verifica se a categoria representa uma reserva/acomodação.
    var isAccommodationCategory: Bool {
        return [.hotels, .camping].contains(category)
    }
    
    /// Verifica se a categoria representa transporte.
    var isTransportCategory: Bool {
        return [.flights, .ubers, .cruises].contains(category)
    }
    
    /// Verifica se a categoria representa atividades/lazer.
    var isActivityCategory: Bool {
        return [.adventures, .restaurants, .shopping, .activities].contains(category)
    }
}


// MARK: - Codable Support (se necessário para persistência)

/**
 Suporte à codificação e decodificação do MenuItem para permitir persistência em armazenamento local, transferência de dados ou sincronização.
 Implementa protocolo Codable para serializar propriedades essenciais do item de menu.
 */
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

