//
//  TravelView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import SwiftUI

struct TravelView: View {
    @StateObject private var viewModel = TravelMenuViewModel()
    @State private var showTransportView = false

    var body: some View {
        NavigationStack {
            VStack {
                HorizontalTravelMenu(
                    selectedCategory: $viewModel.selectedCategory
                )
                { selectedCategory in
                    if selectedCategory == .ubers {
                        showTransportView = true
                    } else {
                            viewModel.filterByCategory(selectedCategory)
                            }
                        }
                                
                                // Conteúdo principal
                        if viewModel.selectedCategory == .ubers {
                                // Quando transporte está selecionado
                            EmptyStateMenuView(category: viewModel.selectedCategory)
                                    .onAppear {
                                    // Mantém os últimos dados visíveis
                                }
                        } else if viewModel.isLoading {
                    ProgressView("Carregando destinos...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredItems.isEmpty {
                    EmptyStateMenuView(category: viewModel.selectedCategory)
                } else {
                    DestinationListView(destinations: viewModel.filteredItems)
                }
            }
            .navigationTitle("My Travel log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.addNewTrip()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showTransportView) {
                            TransportView()
                                .presentationDetents([.large])
                                .presentationDragIndicator(.visible)
                                .onDisappear {
                                    // Volta para Minhas Viagens quando fecha
                                    viewModel.selectedCategory = .myTrips
                                    viewModel.filterByCategory(.myTrips)
                                }
                        }
            .task {
                await viewModel.loadDestinations()
            }
        }
    }
}

#Preview {
    TravelView()
}
