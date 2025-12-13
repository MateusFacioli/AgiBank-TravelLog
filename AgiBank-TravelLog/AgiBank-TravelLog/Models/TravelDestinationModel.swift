//
//  TravelDestinationModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import Foundation

struct TravelDestination: Identifiable, Codable {
    let id: UUID
    var name: String
    var location: String
    var startDate: Date
    var endDate: Date
    var rating: Float
    var notes: String
    var photos: [String]
    var category: TravelCategory
    
    enum TravelCategory: String, Codable, CaseIterable {
        case adventure = "Aventura"
        case relax = "Relax"
        case business = "Negócios"
        case family = "Família"
        case solo = "Solo"
    }
}
