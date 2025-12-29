//
//  DestinationActionsView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI
import UIKit
import CoreLocation
import MapKit

struct DestinationActionsView: View {
    let onFavoriteTapped: (() -> Void)?
    let onShareTapped: (() -> Void)?
    @Binding var currentRating: Float
    let destination: TravelDestination
    let enrichedData: EnrichedDestinationModel?
    
    @StateObject private var viewModel: DestinationCardViewModel
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []
    @State private var isLoadingWeather = false
    
    init(
        onFavoriteTapped: (() -> Void)? = nil,
        onShareTapped: (() -> Void)? = nil,
        currentRating: Binding<Float>,
        destination: TravelDestination,
        enrichedData: EnrichedDestinationModel?
    ) {
        self.onFavoriteTapped = onFavoriteTapped
        self.onShareTapped = onShareTapped
        self._currentRating = currentRating
        self.destination = destination
        self.enrichedData = enrichedData
        _viewModel = StateObject(wrappedValue: DestinationCardViewModel(destination: destination))
    }
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleFavorite()
                onFavoriteTapped?()
            }) {
                Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundColor(viewModel.isFavorited ? .red : .gray)
                    .symbolEffect(.bounce, value: viewModel.isFavorited)
            }
            
            Spacer()
            
            Menu {
                // Opção 1: Compartilhar destino completo
                Button(action: {
                    print("📤 Compartilhando destino completo...")
                    shareItems = viewModel.shareDestination()
                    showingShareSheet = true
                }) {
                    Label("Compartilhar destino", systemImage: "square.and.arrow.up")
                }
                
                // Opção 2: Compartilhar APENAS com foco no clima
                    Button(action: {
                        print("🌤️ Compartilhando apenas clima...")
                        if let message = viewModel.shareWithWeather() {
                            print("✅ Mensagem com clima pronta")
                            shareItems = [message]
                            showingShareSheet = true
                        } else {
                            print("⚠️ Sem dados de clima, usando compartilhamento padrão")
                            shareItems = viewModel.shareDestination()
                            showingShareSheet = true
                        }
                    }) {
                        Label("Compartilhar com clima", systemImage: "cloud.sun.fill")
                    }
                
                Divider()
                
                // Opção 3: Copiar informações
                Button(action: {
                    print("📋 Copiando informações...")
                    copyToClipboard()
                }) {
                    Label("Copiar informações", systemImage: "doc.on.doc")
                }
                
                // Opção 4: Avaliar
                Section("Avaliar") {
                    ForEach(1...5, id: \.self) { star in
                        Button(action: {
                            withAnimation {
                                currentRating = Float(star)
                            }
                        }) {
                            Label("\(star) estrela\(star > 1 ? "s" : "")",
                                  systemImage: star <= Int(currentRating) ? "star.fill" : "star")
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            // Botão de Navegar (opcional)
            Button(action: {
                openInMaps()
            }) {
                Image(systemName: "map")
                    .font(.system(size: 20))
                    .foregroundColor(.green)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.05))
        .onAppear {
                    if enrichedData == nil && !isLoadingWeather {
                        loadWeatherData()
                    }
                }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: shareItems)
                .presentationDetents([.medium, .large])
        }
    }
    
    private func loadWeatherData() {
        isLoadingWeather = true
        Task {
            await viewModel.loadEnrichedData()
            isLoadingWeather = false
        }
    }
    
    private func copyToClipboard() {
        let pasteboard = UIPasteboard.general
        let text = """
        \(destination.name)
        \(destination.location)
        Avaliação: \(String(format: "%.1f", currentRating))/5.0
        Notas: \(destination.notes)
        """
        
        pasteboard.string = text
        
        // Feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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
