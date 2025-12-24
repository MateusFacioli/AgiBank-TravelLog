//
//  TransportFiltersView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import SwiftUI
import CoreLocation

struct TransportFiltersView: View {
    @ObservedObject var viewModel: TransportViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var localSelectedTypes: Set<TransportType>
    @State private var maxPrice: Double = 100.0
    @State private var availableNow: Bool = false
    @State private var showNearbyStations: Bool = false
    @State private var departureTime: Date = Date()
    @State private var sortBy: String = "preco"
    
    init(viewModel: TransportViewModel) {
        self.viewModel = viewModel
        self._localSelectedTypes = State(initialValue: viewModel.selectedTransportTypes)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Tipos de Transporte") {
                    ForEach(TransportType.allCases) { type in
                        Toggle(type.rawValue, isOn: Binding(
                            get: { localSelectedTypes.contains(type) },
                            set: { isSelected in
                                if isSelected {
                                    localSelectedTypes.insert(type)
                                } else {
                                    localSelectedTypes.remove(type)
                                }
                            }
                        ))
                        .toggleStyle(.switch)
                    }
                }
                
                Section("Preferências") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Preço máximo")
                            .font(.headline)
                        
                        HStack {
                            Text("R$ 0")
                            Slider(value: $maxPrice, in: 0...200, step: 10)
                            Text("R$ \(Int(maxPrice))")
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Toggle("Somente disponíveis agora", isOn: $availableNow)
                    Toggle("Mostrar estações próximas", isOn: $showNearbyStations)
                }
                
                Section("Horário") {
                    DatePicker("Partir após", selection: $departureTime,
                              displayedComponents: .hourAndMinute)
                    
                    Picker("Ordenar por", selection: $sortBy) {
                        Text("Tempo mais rápido").tag("tempo")
                        Text("Menor preço").tag("preco")
                        Text("Menor distância").tag("distancia")
                    }
                }
                
                Section("Resumo") {
                    HStack {
                        Text("Tipos selecionados:")
                        Spacer()
                        Text("\(localSelectedTypes.count)/\(TransportType.allCases.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Preço máximo:")
                        Spacer()
                        Text("R$ \(Int(maxPrice))")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Ordenação:")
                        Spacer()
                        Text(sortByDescription)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Filtros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Limpar") {
                        resetToDefaults()
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Aplicar") {
                        applyFilters()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    private var sortByDescription: String {
        switch sortBy {
        case "tempo": return "Tempo mais rápido"
        case "preco": return "Menor preço"
        case "distancia": return "Menor distância"
        default: return "Menor preço"
        }
    }
    
    private func resetToDefaults() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            localSelectedTypes = []
            maxPrice = 0.0
            availableNow = false
            showNearbyStations = false
            departureTime = Date()
            sortBy = "preco"
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    private func applyFilters() {
        viewModel.selectedTransportTypes = localSelectedTypes
        viewModel.searchTransportOptions()
    }
}

struct TransportTypeToggle: View {
    let type: TransportType
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { isSelected },
            set: { onToggle($0) }
        )) {
            HStack {
                Image(systemName: type.icon)
                    .foregroundStyle(type.color)
                    .frame(width: 24)
                
                Text(type.rawValue)
                    .foregroundStyle(.primary)
            }
        }
    }
}

struct ClearFiltersButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "trash")
                Text("Limpar Tudo")
            }
            .foregroundColor(.red)
        }
    }
}

// MARK: - Previews usando MockData

#Preview("Filtros Padrão") {
    let mockViewModel = MockData.createTransportViewModel()
    
    return TransportFiltersView(viewModel: mockViewModel)
        .previewDisplayName("Filtros Padrão")
        .previewLayout(.sizeThatFits)
}

#Preview("Tudo Selecionado") {
    let mockViewModel = MockData.createTransportViewModel()
    mockViewModel.selectedTransportTypes = Set(TransportType.allCases)
    
    return TransportFiltersView(viewModel: mockViewModel)
        .previewDisplayName("Tudo Selecionado")
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
}

#Preview("Filtros Limpos") {
    let mockViewModel = MockData.createTransportViewModel()
    mockViewModel.selectedTransportTypes = []
    
    return TransportFiltersView(viewModel: mockViewModel)
        .previewDisplayName("Filtros Limpos")
        .previewLayout(.sizeThatFits)
}
