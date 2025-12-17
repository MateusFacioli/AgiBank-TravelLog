//
//  DestinationActionsView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct DestinationActionsView: View {
    let onFavoriteTapped: (() -> Void)?
    let onShareTapped: (() -> Void)?
    @Binding var currentRating: Float
    let destination: TravelDestination
    let enrichedData: EnrichedDestinationModel?
    
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []
    
    var body: some View {
        HStack {
            Button(action: { onFavoriteTapped?() }) {
                Label("Favoritar", systemImage: "heart")
                    .labelStyle(.iconOnly)
                    .symbolEffect(.bounce, value: destination.rating)
            }
            Spacer()
            
            Menu {
                Button(action: {
                    prepareShareDestination()
                }) {
                    Label("Compartilhar destino", systemImage: "square.and.arrow.up")
                }
                
                if let enrichedData = enrichedData {
                    Button(action: {
                        prepareShareWithWeather(enrichedData.weather)
                    }) {
                        Label("Compartilhar com clima", systemImage: "cloud.sun.fill")
                    }
                }
                
                Divider()
                
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
                Label("Mais opções", systemImage: "ellipsis.circle")
                    .labelStyle(.iconOnly)
            }
            
            Spacer()
            
            Button(action: {
                openInMaps()
            }) {
                Label("Navegar", systemImage: "map.fill")
                    .labelStyle(.iconOnly)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.05))
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: shareItems)
        }
    }
    
    private func prepareShareDestination() {
        var items: [Any] = ["🎯 \(destination.name)"]
        
        if let enrichedData = enrichedData {
            if let weather = enrichedData.weather {
                items.append("\n🌤️ Clima: \(weather.temperature)°C - \(weather.condition)")
            }
            if let travelTime = enrichedData.travelTime {
                items.append("\n🚗 Tempo de viagem: \(travelTime.duration)")
            }
        }
        
        items.append("\n⭐ Avaliação: \(String(format: "%.1f", currentRating))/5.0")
        items.append("\n✍️ Minha nota: \(destination.notes)")
        
        shareItems = items
        showingShareSheet = true
    }
    
    private func prepareShareWithWeather(_ weather: WeatherDataModel?) {
        guard let weather = weather else { return }
        
        let message = """
        🌍 Destino: \(destination.name)
        📍 Local: \(destination.location)
        🌤️ Clima: \(weather.temperature)°C - \(weather.condition)
        💧 Umidade: \(weather.humidity)%
        💨 Vento: \(weather.windSpeed) km/h
        ⭐ Minha avaliação: \(String(format: "%.1f", currentRating))/5.0
        """
        
        shareItems = [message]
        showingShareSheet = true
    }
    
    private func openInMaps() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destination.location) { placemarks, error in
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("❌ Não foi possível encontrar o local")
                return
            }
            
            let mapItem = MKMapItem(placemark: MKPlacemark(placemark: placemark))
            mapItem.name = destination.name
            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
