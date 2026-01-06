//
//  TransportView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

/**
 Módulo de Transporte: exibe mapa, busca e lista de opções de transporte próximas.
 
 - Integra mapa (MapKit) com controles de busca, filtros e resultados em lista horizontal.
 - Usa `TransportViewModel` para gerenciar localização do usuário, raio de busca e resultados.
 - Apresenta detalhes e filtros via sheets, com overlays de carregamento quando necessário.
 */

import SwiftUI
import CoreLocation
import MapKit

/// Tela principal do módulo de transporte com mapa, barra de busca, filtros e lista de opções.
struct TransportView: View {
    /// ViewModel responsável por estado de localização, busca e resultados de transporte.
    @StateObject private var viewModel = TransportViewModel()
    /// Controla a apresentação da folha de filtros de transporte.
    @State private var showingFilters = false
    /// Opção de transporte selecionada para exibir detalhes em sheet.
    @State private var selectedTransport: TransportOptionModel?
    
    /// Estrutura de navegação com mapa, controles flutuantes e lista de resultados.
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Mapa principal
                TransportMapView(viewModel: viewModel)
                    .ignoresSafeArea(edges: .top)
                
                // Overlay com controles
                VStack(spacing: 0) {
                    // Barra de busca
                    SearchBarView(viewModel: viewModel)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    Spacer()
                    
                    // Controles flutuantes
                    FloatingControlsView(
                        viewModel: viewModel,
                        showingFilters: $showingFilters
                    )
                    
                    // Lista de transportes
                    if !viewModel.transportOptions.isEmpty {
                        TransportListview(
                            options: viewModel.transportOptions,
                            selectedTransport: $selectedTransport
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .navigationTitle("Transporte")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.centerOnUserLocation()
                    }) {
                        Image(systemName: "location.fill")
                            .symbolEffect(.bounce, value: viewModel.userLocation)
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                TransportFiltersView(viewModel: viewModel)
            }
            .sheet(item: $selectedTransport) { transport in
                TransportDetailView(transport: transport)
            }
            .alert("Permissão de Localização", 
                   isPresented: $viewModel.showLocationAlert) {
                Button("Abrir Configurações") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("Precisamos da sua localização para mostrar opções de transporte próximas.")
            }
            .overlay {
                if viewModel.isLoading {
                    LoadingOverlayView()
                }
            }
        }
    }
}

/// Barra de busca para endereços/pontos, disparando pesquisa no ViewModel ao submeter texto.
struct SearchBarView: View {
    /// ViewModel usado para realizar a busca quando o usuário submete o texto.
    @ObservedObject var viewModel: TransportViewModel
    /// Texto digitado na barra de busca.
    @State private var searchText = ""
    
    /// Campo de texto com ícone de busca e botão para limpar conteúdo.
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Buscar endereço ou ponto...", text: $searchText)
                .textFieldStyle(.plain)
                .onSubmit {
                    viewModel.searchForLocation(searchText)
                }
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}

/// Controles flutuantes para filtros e ajuste do raio de busca.
struct FloatingControlsView: View {
    /// ViewModel que reflete e atualiza o raio de busca.
    @ObservedObject var viewModel: TransportViewModel
    /// Binding que controla a apresentação da folha de filtros.
    @Binding var showingFilters: Bool
    
    /// Botão de filtros e slider para ajustar o raio de busca com feedback textual.
    var body: some View {
        HStack(spacing: 16) {
            // Botão de filtros
            Button(action: { showingFilters.toggle() }) {
                Label("Filtrar", systemImage: "slider.horizontal.3")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
            }
            
            // Slider de raio
            VStack(spacing: 4) {
                Slider(
                    value: $viewModel.searchRadius,
                    in: 0.5...20,
                    step: 0.5
                ) {
                    Text("Raio de busca")
                } minimumValueLabel: {
                    Text("0.5km")
                        .font(.caption)
                } maximumValueLabel: {
                    Text("20km")
                        .font(.caption)
                }
                .onChange(of: viewModel.searchRadius) { _, _ in
                    viewModel.searchTransportOptions()
                }
                
                Text("Raio: \(String(format: "%.1f", viewModel.searchRadius))km")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: 200)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
        }
        .padding()
    }
}

/// Lista horizontal de cartões de opções de transporte.
struct TransportListview: View {
    /// Coleção de opções de transporte a serem exibidas.
    let options: [TransportOptionModel]
    /// Binding para a opção selecionada, usada para abrir o detalhe.
    @Binding var selectedTransport: TransportOptionModel?
    
    /// Scroll horizontal com cartões; toca para selecionar e abrir detalhes.
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(options) { option in
                    TransportCardView(option: option)
                        .onTapGesture {
                            selectedTransport = option
                        }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(height: 160)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
    }
}

/// Cartão visual de uma opção de transporte, mostrando ícone, nome, duração, distância e preço.
struct TransportCardView: View {
    /// Dados da opção de transporte exibida no cartão.
    let option: TransportOptionModel
    
    /// Layout do cartão com ícone destacado e informações resumidas.
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Ícone do tipo de transporte
            Image(systemName: option.icon)
                .font(.title2)
                .foregroundStyle(option.color)
                .frame(width: 44, height: 44)
                .background(option.color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(option.name)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("\(option.duration) min")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                
                HStack {
                    Image(systemName: "arrow.triangle.swap")
                        .font(.caption)
                    Text("\(option.distance) km")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                
                if let price = option.price {
                    Text(price)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(12)
        .frame(width: 150)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

/// Overlay semitransparente com indicador de progresso enquanto busca opções.
struct LoadingOverlayView: View {
    /// Fundo escurecido com `ProgressView` e mensagem informativa.
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                
                Text("Buscando opções de transporte...")
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .padding(32)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

/// Preview da tela principal do módulo de transporte.
#Preview {
    TransportView()
}

/// Helper para criar uma opção de transporte de exemplo (usado em Previews).
@MainActor
private func createSampleTransport() -> TransportOptionModel {
    TransportOptionModel(
        name: "Uber X Premium",
        type: .rideSharing,
        icon: "car.fill",
        color: .blue,
        coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333),
        duration: 12,
        distance: 4.5,
        price: "R$ 22-28",
        details: [
            "Carro premium (Toyota Corolla)",
            "Motorista com 4.9★ avaliação",
            "Chega em 3-5 minutos",
            "Ar condicionado e Wi-Fi"
        ]
    )
}

/// Helper para criar um ViewModel com dados mockados para Previews.
@MainActor
private func createMockMapViewModel() -> TransportViewModel {
    let viewModel = TransportViewModel()
    
    viewModel.transportOptions = MockData.transportOptions
    viewModel.selectedTransportTypes = Set(TransportType.allCases)
    viewModel.userLocation = CLLocation(
        latitude: -23.5505,
        longitude: -46.6333
    )
    
    return viewModel
}

/// Conjunto de Previews com diferentes telas do módulo de transporte.
#Preview("Transport Module Preview") {
    VStack(spacing: 0) {
        // Header
        Text("Módulo de Transporte")
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(.blue.opacity(0.1))
        
        // Conteúdo das previews
        TabView {
            // Tab 1: Detalhes
            TransportDetailView(transport: MockData.transportSample)
                .tabItem {
                    Label("Detalhes", systemImage: "info.circle")
                }
            
            // Tab 2: Filtros
            TransportFiltersView(viewModel: MockData.createTransportViewModel())
                .tabItem {
                    Label("Filtros", systemImage: "slider.horizontal.3")
                }
            
            // Tab 3: Mapa
            TransportMapView(viewModel: MockData.createTransportViewModel())
                .frame(height: 400)
                .tabItem {
                    Label("Mapa", systemImage: "map")
                }
        }
        .frame(height: 500)
        .tabViewStyle(.page)
    }
    .padding()
}

/// Preview de tamanho de dispositivo específico.
#Preview("iPhone 15 Pro") {
    TransportDetailView(transport: MockData.transportSample)
        .previewDevice("iPhone 15 Pro")
        .previewDisplayName("iPhone 15 Pro")
}

/// Preview em modo escuro.
#Preview("Dark Mode") {
    TransportDetailView(transport: MockData.transportSample)
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
}
