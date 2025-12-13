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
            VStack {
                // Menu principal - corrigido com Binding
                HorizontalTravelMenu(
                    selectedCategory: $viewModel.selectedCategory
                )
                .onChange(of: viewModel.selectedCategory) { _, newCategory in
                    viewModel.filterByCategory(newCategory)
                }

                if viewModel.isLoading {
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
            .task {
                await viewModel.loadDestinations()
            }
        }
    }
}

#Preview {
    TravelView()
}
