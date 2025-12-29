//
//  DestinationListView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import SwiftUI

struct DestinationListView: View {
    let destinations: [TravelDestination]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(destinations) { destination in
                    DestinationCardView(
                        destination: destination,
                        onFavoriteTapped: {
                            handleFavoriteTapped(for: destination)
                        },
                        onShareTapped: {
                            handleShareTapped(for: destination)
                        }
                    )
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
        }
    }
    
    private func handleFavoriteTapped(for destination: TravelDestination) {
        print("✅ Destino favoritado: \(destination.name)")
        
        // Feedback haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func handleShareTapped(for destination: TravelDestination) {
        print("📤 Compartilhando: \(destination.name)")
        
        // Feedback haptic
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
