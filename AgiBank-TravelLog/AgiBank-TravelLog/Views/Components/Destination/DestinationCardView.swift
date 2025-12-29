//
//  DestinationCardView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import SwiftUI

struct DestinationCardView: View {
    @StateObject private var viewModel: DestinationCardViewModel
    @EnvironmentObject private var favoritesVM: FavoritesViewModel
    private let destination: TravelDestination
    private let onFavoriteTapped: (() -> Void)?
    private let onShareTapped: (() -> Void)?
    
    init(
        destination: TravelDestination,
        onFavoriteTapped: (() -> Void)? = nil,
        onShareTapped: (() -> Void)? = nil
    ) {
        self.destination = destination
        self.onFavoriteTapped = onFavoriteTapped
        self.onShareTapped = onShareTapped
        _viewModel = StateObject(wrappedValue: DestinationCardViewModel(destination: destination))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DestinationHeaderView(
                destination: destination,
                enrichedData: viewModel.enrichedData,
                selectedPhotoIndex: $viewModel.selectedPhotoIndex
            )
            
//            DestinationHeaderView(
//                destination: MockData.travelDestination,
//                enrichedData: MockData.enrichedDestinationModel,
//                selectedPhotoIndex: .constant(0)
//            )
//            
            VStack(alignment: .leading, spacing: 8) {
                headerView
                if let weather = viewModel.enrichedData?.weather {
                    WeatherCardView(
                        weather: weather,
                        additionalConditions: viewModel.additionalWeatherConditions,
                        weatherService: WeatherService()
                    )
                    
                    if !viewModel.weatherRecommendations.isEmpty {
                        WeatherRecommendationsView(
                            recommendations: viewModel.weatherRecommendations
                        )
                    }
                }
                
                if let enrichedData = viewModel.enrichedData {
                    additionalInfoView(enrichedData)
                }
                
                Text(destination.notes)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            .padding(16)
            
            DestinationActionsView(
                onFavoriteTapped: onFavoriteTapped,
                onShareTapped: onShareTapped,
                currentRating: $viewModel.currentRating,
                destination: destination,
                enrichedData: viewModel.enrichedData
            )
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .task {
            await viewModel.loadEnrichedData()
        }
    }
    
    private func favoriteButton() -> some View {
            Button(action: {
                viewModel.toggleFavorite()
                favoritesVM.toggleFavorite(for: destination)
                onFavoriteTapped?()
            }) {
                Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isFavorited ? .red : .gray)
            }
        }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(destination.name)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                    
                    Label(
                        destination.location,
                        systemImage: "mappin.circle.fill"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                RatingView(rating: $viewModel.currentRating, size: 16)
            }
        }
    }
    
    private func additionalInfoView(_ data: EnrichedDestinationModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let travelTime = data.travelTime {
                travelTimeView(travelTime)
            }
            
            if let bestSeason = data.bestSeason {
                bestSeasonView(bestSeason)
            }
            
            if !data.localReviews.isEmpty,
               let topReview = data.localReviews.first {
                localReviewsView(topReview)
            }
        }
    }
    
    private func travelTimeView(_ travelTime: TravelTimeDataModel) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "car.fill")
                .font(.caption)
                .foregroundStyle(.green)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Tempo de viagem")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Text("\(travelTime.duration) (\(travelTime.distance))")
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
    }
    
    private func bestSeasonView(_ bestSeason: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .font(.caption)
                .foregroundStyle(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Melhor época")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Text(bestSeason)
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
    }
    
    private func localReviewsView(_ topReview: LocalReviewModel) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "star.circle.fill")
                .font(.caption)
                .foregroundStyle(.yellow)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Avaliações locais")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Text("\(topReview.source): \(String(format: "%.1f", topReview.rating))/5.0")
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
    }
}

// MARK: - Preview
#Preview("Default") {
    DestinationCardView(
        destination: MockData.travelDestination,
        onFavoriteTapped: {
            print("Favoritado!")
        },
        onShareTapped: {
            print("Compartilhado!")
        }
    )
    .padding()
}

#Preview("Multiple Destinations") {
    ScrollView {
        VStack(spacing: 20) {
            ForEach(MockData.travelDestinations) { destination in
                DestinationCardView(destination: destination) {
                    print("Favoritado: \(destination.name)")
                } onShareTapped: {
                    print("Compartilhado: \(destination.name)")
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

#Preview("Dark Mode") {
    DestinationCardView(
        destination: MockData.travelDestinations[0],
        onFavoriteTapped: {
            print("Favoritado!")
        },
        onShareTapped: {
            print("Compartilhado!")
        }
    )
    .preferredColorScheme(.dark)
    .padding()
}

// Preview com dados enriquecidos (simulado)
#Preview("Com dados do clima") {
    let destination = MockData.travelDestination
    let view = DestinationCardView(
        destination: destination,
        onFavoriteTapped: {
            print("Favoritado!")
        },
        onShareTapped: {
            print("Compartilhado!")
        }
    )
    
    return view
        .padding()
        .task {
        }
}

// Preview para diferentes categorias
#Preview("Categoria Praia") {
    let beachDestination = TravelDestination(
        id: UUID(),
        name: "Praia do Forte",
        location: "Bahia, Brasil",
        startDate: Date()-15,
        endDate: Date(),
        rating: 4.8,
        notes: "Uma das praias mais bonitas do Brasil",
        photos: ["https://example.com/beach.jpg"],
        category: TravelDestination.TravelCategory.adventure,
    )
    
    DestinationCardView(destination: beachDestination)
        .padding()
}
