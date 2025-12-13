//
//  CompactTravelMenu.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import SwiftUI

struct CompactTravelMenuPreview: View {
    @State private var selectedCategory: MenuItem.MenuCategory = .myTrips
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(MenuItem.MenuCategory.allCases.prefix(5), id: \.self) { category in
                    CategoryCapsule(
                        title: category.title,
                        isSelected: category == selectedCategory
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CategoryCapsule: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.medium)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background {
                Capsule()
                    .fill(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
            }
            .foregroundStyle(isSelected ? .white : .secondary)
            .contentShape(Capsule())
    }
}
