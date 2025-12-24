//
//  TravelView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 11/12/25.
//

import SwiftUI

struct TravelView: View {
    @StateObject private var viewModel = TravelMenuViewModel()
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HorizontalTravelMenu(
                    selectedCategory: $viewModel.selectedCategory
                ) { selectedCategory in
                    viewModel.filterByCategory(selectedCategory)
                }
            
                Group {
                    if viewModel.selectedCategory == .ubers {
                        TransportView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.isLoading {
                        ProgressView("Carregando destinos...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredItems.isEmpty {
                        EmptyStateMenuView(category: viewModel.selectedCategory)
                    } else {
                        DestinationListView(destinations: viewModel.filteredItems)
                    }
                }
            }
            .navigationTitle(navigationTitle)
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
            .task {
                await viewModel.loadDestinations()
            }
        }
    }
    
    private var navigationTitle: String {
        viewModel.selectedCategory.rawValue
    }
}

#Preview {
    TravelView()
}

#Preview("Transporte Selecionado") {
    let viewModel = TravelMenuViewModel()
    viewModel.selectedCategory = .ubers
    
    return TravelView()
        .environmentObject(viewModel)
}
