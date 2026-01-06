/**
 View responsável por ações rápidas de um destino (favoritar, compartilhar, avaliar e abrir no Mapas).
 
 - Apresenta um menu de ações com opções de compartilhamento (com e sem clima), cópia para a área de transferência e avaliação por estrelas.
 - Integra-se com `DestinationCardViewModel` para obter e atualizar dados enriquecidos (ex.: clima) e estado de favorito.
 - Pode disparar callbacks externos (`onFavoriteTapped`, `onShareTapped`) para que a tela pai reaja a interações.
*/

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

/// Componente SwiftUI que exibe botões e menu de ações para um destino específico.
/// Controla favoritos, compartilhamento e navegação, além de permitir avaliar o destino.
struct DestinationActionsView: View {
    /// Callback opcional disparado após o usuário tocar no botão de favorito.
    let onFavoriteTapped: (() -> Void)?
    /// Callback opcional disparado após o usuário iniciar um fluxo de compartilhamento.
    let onShareTapped: (() -> Void)?
    /// Binding para a avaliação atual do destino (1 a 5 estrelas).
    @Binding var currentRating: Float
    /// Modelo do destino exibido.
    let destination: TravelDestination
    /// Dados enriquecidos do destino (ex.: clima, tempo de viagem), quando já disponíveis.
    let enrichedData: EnrichedDestinationModel?
    
    /// ViewModel responsável por lógica de favoritos, compartilhamento e carregamento de dados enriquecidos.
    @StateObject private var viewModel: DestinationCardViewModel
    /// Controla a apresentação do ShareSheet nativo.
    @State private var showingShareSheet = false
    /// Itens que serão compartilhados pelo ShareSheet.
    @State private var shareItems: [Any] = []
    /// Indica se o carregamento de dados de clima está em andamento.
    @State private var isLoadingWeather = false
    
    /// Inicializador do componente de ações do destino.
    /// - Parameters:
    ///   - onFavoriteTapped: Callback opcional após tocar em favorito.
    ///   - onShareTapped: Callback opcional após iniciar compartilhamento.
    ///   - currentRating: Binding para a avaliação exibida/ajustada na UI.
    ///   - destination: Modelo do destino alvo das ações.
    ///   - enrichedData: Dados enriquecidos (se já carregados) para alimentar opções de compartilhamento.
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
    
    /// Layout principal com botões de favorito, menu de ações e atalho para Mapas.
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
    
    /// Dispara o carregamento assíncrono de dados enriquecidos (clima) via ViewModel.
    private func loadWeatherData() {
        isLoadingWeather = true
        Task {
            await viewModel.loadEnrichedData()
            isLoadingWeather = false
        }
    }
    
    /// Copia informações resumidas do destino para a área de transferência e emite feedback háptico.
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
    
    /// Abre o endereço do destino no app Mapas utilizando geocodificação do `CoreLocation`.
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

/// Wrapper SwiftUI para apresentar `UIActivityViewController` (ShareSheet) com itens fornecidos.
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    /// Cria e retorna o `UIActivityViewController` configurado com os itens.
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    /// Atualizações não necessárias para este caso de uso (sem estado dinâmico após criação).
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
