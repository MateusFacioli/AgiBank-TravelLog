//
//  TravelViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import SwiftUI

/// ViewModel responsável por gerenciar a lista de destinos exibida na UI.
///
/// Fornece métodos assíncronos para carregar e adicionar destinos, mantém estados
/// de carregamento e erro, além de expor filtros por categoria.
@MainActor
class TravelViewModel: ObservableObject {
    /// Lista de destinos carregados.
    @Published var destinations: [TravelDestination] = []
    /// Categoria atualmente selecionada (nil = todas).
    @Published var selectedCategory: TravelDestination.TravelCategory?
    /// Indica se uma operação de carregamento está em andamento.
    @Published var isLoading = false
    /// Mensagem de erro (se houver) após operações assíncronas.
    @Published var error: String?
    
    private let repository: TravelRepository
    
    /// Inicializador padrão.
    /// - Parameter repository: repositório usado para buscar/gravar destinos (injetável para testes).
    init(repository: TravelRepository = TravelRepository.shared) {
        self.repository = repository
    }
    
    /// Carrega destinos de forma assíncrona usando o `repository`.
    ///
    /// Atualiza `isLoading` enquanto a operação estiver em andamento e define `error`
    /// em caso de falha.
    func loadDestinations() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            destinations = try await repository.fetchDestinations()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    /// Adiciona um destino via repositório e recarrega a lista.
    /// - Parameter destination: destino a ser salvo.
    func addDestination(_ destination: TravelDestination) async {
        do {
            try await repository.saveDestination(destination)
            await loadDestinations()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    /// Retorna a lista de destinos filtrada pela categoria selecionada.
    var filteredDestinations: [TravelDestination] {
        guard let category = selectedCategory else { return destinations }
        return destinations.filter { $0.category == category }
    }
}
