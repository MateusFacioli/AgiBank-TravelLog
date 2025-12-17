//
//  DestinationHeaderView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//


import SwiftUI

struct DestinationHeaderView: View {
    let destination: TravelDestination
    let enrichedData: EnrichedDestinationModel?
    @Binding var selectedPhotoIndex: Int
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let photos = enrichedData?.photos, !photos.isEmpty {
                TabView(selection: $selectedPhotoIndex) {
                    ForEach(Array(photos.enumerated()), id: \.offset) { index, photoUrl in
                        AsyncImage(url: URL(string: photoUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(.gray.opacity(0.2))
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                AsyncImage(url: URL(string: destination.photos.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .frame(height: 180)
                .clipped()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                CategoryBadgeView(category: destination.category)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                if let photos = enrichedData?.photos, photos.count > 1 {
                    HStack(spacing: 4) {
                        ForEach(0..<min(photos.count, 5), id: \.self) { index in
                            Circle()
                                .fill(selectedPhotoIndex == index ? Color.white : Color.white.opacity(0.5))
                                .frame(width: 6, height: 6)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }
            }
            .padding(8)
        }
    }
}

// MARK: - Previews

#Preview("Com fotos enriquecidas") {
    @State var selectedPhotoIndex = 0
    
    DestinationHeaderView(
        destination: MockData.travelDestination,
        enrichedData: MockData.enrichedDestinationModel,
        selectedPhotoIndex: $selectedPhotoIndex
    )
    .frame(height: 200)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Com apenas uma foto") {
    @State var selectedPhotoIndex = 0
    
    let simpleDestination = TravelDestination(
        id: UUID(),
        name: "Destino Simples",
        location: "Localização",
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400 * 7),
        rating: 4.5,
        notes: "Notas sobre o destino",
        photos: ["https://images.unsplash.com/photo-1502602898457-c46ad927bd85"],
        category: .relax
    )
    
    let simpleEnrichedData = EnrichedDestinationModel(
        destinationId: simpleDestination.id,
        weather: nil,
        photos: ["https://images.unsplash.com/photo-1502602898457-c46ad927bd85"],
        localReviews: [],
        nearbyAttractions: [""],
        travelTime: nil,
        bestSeason: nil,
        lastUpdated: Date()
    )
    
    DestinationHeaderView(
        destination: simpleDestination,
        enrichedData: simpleEnrichedData,
        selectedPhotoIndex: $selectedPhotoIndex
    )
    .frame(height: 200)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Sem fotos enriquecidas") {
    @State var selectedPhotoIndex = 0
    
    let destinationNoPhotos = TravelDestination(
        id: UUID(),
        name: "Destino sem fotos extras",
        location: "Localização",
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400 * 7),
        rating: 4.5,
        notes: "Notas sobre o destino",
        photos: ["https://images.unsplash.com/photo-1502602898457-c46ad927bd85"],
        category: .adventure
    )
    
    return DestinationHeaderView(
        destination: destinationNoPhotos,
        enrichedData: nil,
        selectedPhotoIndex: $selectedPhotoIndex
    )
    .frame(height: 200)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Com múltiplas fotos") {
    @State var selectedPhotoIndex = 0
    
    let multiPhotoDestination = TravelDestination(
        id: UUID(),
        name: "Destino com múltiplas fotos",
        location: "Localização",
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400 * 7),
        rating: 4.5,
        notes: "Notas sobre o destino",
        photos: ["https://images.unsplash.com/photo-1502602898457-c46ad927bd85"],
        category: .family
    )
    
    let multiPhotoEnrichedData = EnrichedDestinationModel(
        destinationId: multiPhotoDestination.id,
        weather: nil,
        photos: [
            "https://images.unsplash.com/photo-1502602898457-c46ad927bd85",
            "https://images.unsplash.com/photo-1499856871958-5b9627545d1a",
            "https://images.unsplash.com/photo-1523531294919-4bcd7c65e216",
            "https://images.unsplash.com/photo-1528825871115-3581a5387919"
        ],
        localReviews: [],
        nearbyAttractions: [""],
        travelTime: nil,
        bestSeason: nil,
        lastUpdated: Date()
    )
    
    DestinationHeaderView(
        destination: multiPhotoDestination,
        enrichedData: multiPhotoEnrichedData,
        selectedPhotoIndex: $selectedPhotoIndex
    )
    .frame(height: 200)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Dark Mode") {
    @State var selectedPhotoIndex = 0
    
    DestinationHeaderView(
        destination: MockData.travelDestination,
        enrichedData: MockData.enrichedDestinationModel,
        selectedPhotoIndex: $selectedPhotoIndex
    )
    .frame(height: 200)
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
