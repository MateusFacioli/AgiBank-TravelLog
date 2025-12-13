//
//  FilterableTravelMenu.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import SwiftUI

struct FilterableTravelMenu: View {
    @Binding var selectedFilters: Set<MenuItem.MenuCategory>
    var onFilterChanged: ((Set<MenuItem.MenuCategory>) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(MenuItem.MenuCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.title,
                        isSelected: selectedFilters.contains(category),
                        systemImage: category.icon
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            if selectedFilters.contains(category) {
                                selectedFilters.remove(category)
                            } else {
                                selectedFilters.insert(category)
                            }
                            onFilterChanged?(selectedFilters)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let systemImage: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.caption)
                .symbolEffect(.bounce, value: isSelected)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            Capsule()
                .fill(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
        }
        .foregroundStyle(isSelected ? .white : .secondary)
        .overlay {
            Capsule()
                .stroke(
                    isSelected ? Color.accentColor.opacity(0.3) : Color.gray.opacity(0.2),
                    lineWidth: 1
                )
        }
        .contentShape(Capsule())
    }
}

// MARK: - Preview
#Preview {
    FilterableTravelMenuPreview()
        .padding()
}

//// Preview Helper
struct FilterableTravelMenuPreview: View {
    @State private var selectedFilters: Set<MenuItem.MenuCategory> = [.myTrips, .flights]
    
    var body: some View {
        VStack {
            Text("Menu de Filtros")
                .font(.headline)
                .padding(.bottom)
            
            FilterableTravelMenu(
                selectedFilters: $selectedFilters
            ) { filters in
                print("Filtros selecionados: \(filters)")
            }
            
            Text("Filtros ativos: \(selectedFilters.map { $0.title }.joined(separator: ", "))")
                .font(.caption)
                .padding(.top)
        }
    }
}
