//
//  DestinationCardView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import SwiftUI

struct DestinationCardView: View {
    let destination: TravelDestination
    var onFavoriteTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DestinationHeader(destination: destination)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(destination.name)
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                
                HStack {
                    Label(destination.location, systemImage: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    //MARK: TODO
                    //RatingView(rating: destination.rating)
                }
                
                Text(destination.notes)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            
            DestinationActions(
                onFavoriteTapped: onFavoriteTapped,
                onShareTapped: onShareTapped
            )
        }
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
}

#Preview {
    let sampleDestination = TravelDestination(
            id: UUID(),
            name: "Paris, França",
            location: "Europa",
            startDate: Date(),
            endDate: Date()+15,
            rating: 5.8,
            notes: "Conhecida como a Cidade Luz, Paris é famosa por sua arquitetura icônica, museus de classe mundial e culinária refinada.",
            photos: ["https://example.com/paris.jpg"],
            category: .relax
        )
        
        DestinationCardView(destination: sampleDestination) {
            // Ação de favoritar
            print("Favoritado!")
        } onShareTapped: {
            // Ação de compartilhar
            print("Compartilhado!")
        }
}


// MARK: - Subviews using ViewBuilder
extension DestinationCardView {
    @ViewBuilder
    private func DestinationHeader(destination: TravelDestination) -> some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: destination.photos.first ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(.gray.opacity(0.2))
            }
            .frame(height: 180)
            .clipped()
            
            //MARK: TODO
//            CategoryBadge(category: destination.category)
//                .padding(8)
        }
    }
    
    @ViewBuilder
    private func DestinationActions(
        onFavoriteTapped: (() -> Void)?,
        onShareTapped: (() -> Void)?
    ) -> some View {
        HStack {
            Button(action: { onFavoriteTapped?() }) {
                Label("Favoritar", systemImage: "heart")
                    .labelStyle(.iconOnly)
            }
            
            Spacer()
            
            Button(action: { onShareTapped?() }) {
                Label("Compartilhar", systemImage: "square.and.arrow.up")
                    .labelStyle(.iconOnly)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.gray.opacity(0.1))
    }
}
