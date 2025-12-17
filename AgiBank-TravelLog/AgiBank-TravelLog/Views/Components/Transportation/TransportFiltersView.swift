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
                            Slider(value: .constant(50), in: 0...100)
                            Text("R$ 100+")
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Toggle("Somente disponíveis agora", isOn: .constant(true))
                    Toggle("Mostrar estações próximas", isOn: .constant(true))
                }
                
                Section("Horário") {
                    DatePicker("Partir após", selection: .constant(Date()),
                              displayedComponents: .hourAndMinute)
                    
                    Picker("Ordenar por", selection: .constant("tempo")) {
                        Text("Tempo mais rápido").tag("tempo")
                        Text("Menor preço").tag("preco")
                        Text("Menor distância").tag("distancia")
                    }
                }
            }
            .navigationTitle("Filtros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Limpar") {
                        localSelectedTypes = Set(TransportType.allCases)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Aplicar") {
                        viewModel.selectedTransportTypes = localSelectedTypes
                        viewModel.searchTransportOptions()
                            dismiss()
                        }
                    }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Concluir") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
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
            Label(type.rawValue, systemImage: type.icon)
                .foregroundStyle(type.color)
        }
    }
}

#Preview {
    // Crie um ViewModel mock para o preview
    let mockViewModel = TransportViewModel()
    
    return TransportFiltersView(viewModel: mockViewModel)
        .previewDisplayName("Transport Filters")
        .previewLayout(.sizeThatFits)
}

#Preview("Filters with Selections") {
    let mockViewModel = TransportViewModel()
    
    // Simule algumas seleções para o preview
    Task { @MainActor in
        mockViewModel.selectedTransportTypes = [.rideSharing, .taxi, .bus]
    }
    
    return TransportFiltersView(viewModel: mockViewModel)
        .previewDisplayName("Filters with Selections")
}

#Preview("Empty Filters") {
    let mockViewModel = TransportViewModel()
    
    // Comece com filtros vazios
    Task { @MainActor in
        mockViewModel.selectedTransportTypes = []
    }
    
    return TransportFiltersView(viewModel: mockViewModel)
        .previewDisplayName("Empty Filters")
}

// MARK: - Mock TransportViewModel para Previews
extension TransportViewModel {
    // Inicializador conveniente para previews
    convenience init(forPreview: Bool) {
        self.init()
        
        // Configurações específicas para preview
        if forPreview {
            // Inicializa com alguns tipos selecionados
            self.selectedTransportTypes = [.rideSharing, .taxi, .bus]
            
            // Mock de localização para preview
            self.userLocation = CLLocation(
                latitude: -23.5505,
                longitude: -46.6333
            )
        }
    }
}
