//
//  WeatherRecommendationsView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI

struct WeatherRecommendationsView: View {
    let recommendations: [WeatherRecommendation]
    
    var body: some View {
        if !recommendations.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Recomendações")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                VStack(spacing: 8) {
                    ForEach(recommendations.sorted(by: { $0.priority.order > $1.priority.order })) { recommendation in
                        HStack(spacing: 12) {
                            Image(systemName: recommendation.icon)
                                .font(.callout)
                                .foregroundStyle(recommendation.priority.color)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(recommendation.title)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)
                                
                                Text(recommendation.description)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(12)
            .background(Color.blue.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
