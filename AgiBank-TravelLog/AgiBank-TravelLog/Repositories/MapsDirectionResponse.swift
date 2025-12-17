//
//  MapsDirectionResponse.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//


// MARK: - API Response Models

struct MapsDirectionResponse: Codable {
    let routes: [Route]
    
    struct Route: Codable {
        let legs: [Leg]
    }
    
    struct Leg: Codable {
        let distance: Distance
        let duration: Duration
        let value: Int
        let steps: [Step]
    }
    
    struct Distance: Codable {
        let text: String
        let value: Int
    }
    
    struct Duration: Codable {
        let text: String
        let value: Int
    }
    
    struct Step: Codable {
        let instructions: String
    }
}
