//
//  EnrichedDestinationModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import Foundation

struct EnrichedDestinationModel: Codable {
    let destinationId: UUID
    var weather: WeatherDataModel?
    var photos: [String]
    var localReviews: [LocalReviewModel]
    var nearbyAttractions: [String]
    var travelTime: TravelTimeDataModel?
    var bestSeason: String?
    var lastUpdated: Date
}
