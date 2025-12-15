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
    @State private var currentRating: Float

    init(
        destination: TravelDestination,
        onFavoriteTapped: (() -> Void)? = nil,
        onShareTapped: (() -> Void)? = nil
    ) {

        self.destination = destination
        self.onFavoriteTapped = onFavoriteTapped
        self.onShareTapped = onShareTapped
        self._currentRating = State(initialValue: destination.rating)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DestinationHeader(destination: destination)

            VStack(alignment: .leading, spacing: 8) {
                Text(destination.name)
                    .font(.title3.bold())
                    .foregroundStyle(.primary)

                HStack {
                    Label(
                        destination.location,
                        systemImage: "mappin.circle.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Spacer()
                    
                    RatingView(rating: $currentRating, size: 16)
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

// MARK: - Subviews using ViewBuilder
extension DestinationCardView {
    @ViewBuilder
    private func DestinationHeader(destination: TravelDestination) -> some View
    {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: URL(string: destination.photos.first ?? "")) {
                image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(.gray.opacity(0.2))
            }
            .frame(height: 180)
            .clipped()

            // Category Badge com rating
            VStack(alignment: .trailing, spacing: 4) {
                // CategoryBadge(category: destination.category)
                // Mini rating no header
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(
                            systemName: miniStarType(
                                for: index,
                                rating: destination.rating
                            )
                        )
                        .font(.system(size: 8))
                        .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }
            .padding(8)
        }
    }

    private func miniStarType(for index: Int, rating: Float) -> String {

        let indexFloat = Float(index)

        if rating >= indexFloat {
            return "star.fill"
        } else if rating >= indexFloat - 0.5 {
            return "star.leadinghalf.filled"

        } else {
            return "star"
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
                    .symbolEffect(.bounce, value: destination.rating)
            }

            Spacer()
            // Botão para avaliar
            Menu {
                ForEach(1...5, id: \.self) { star in

                    Button(action: {
                        withAnimation {
                            currentRating = Float(star)
                        }
                    }) {
                        Label("\(star) estrela\(star > 1 ? "s" : "")",
                              systemImage: star >= 3 ? "star.fill" : "star")
                    }
                }
            } label: {
                Label("Avaliar", systemImage: "star.bubble")
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


#Preview {
    VStack(spacing: 20) {
        let sampleDestination = TravelDestination(
            id: UUID(),
            name: "Paris, França",
            location: "Europa",
            startDate: Date(),
            endDate: Date()+15,
            rating: 4.8,
            notes: "Conhecida como a Cidade Luz, Paris é famosa por sua arquitetura icônica, museus de classe mundial e culinária refinada.",
            photos: ["https://example.com/paris.jpg"],
            category: .relax
        )
        
        DestinationCardView(destination: sampleDestination) {
            print("Favoritado!")
        } onShareTapped: {
            print("Compartilhado!")
        }
        .padding()
        
        // Demonstração do RatingView isolado
        VStack {
            Text("Componente de Avaliação")
                .font(.headline)
            
            Divider()
            
            VStack(spacing: 20) {
                Text("Interativo:")
                RatingView(rating: .constant(3.5), size: 24)
                
                Text("Somente leitura:")
                StaticRatingView(rating: 4.2, size: 20)
                
                Text("Customizado:")
                AnimatedStarRating(rating: .constant(4), size: 30)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }
}
