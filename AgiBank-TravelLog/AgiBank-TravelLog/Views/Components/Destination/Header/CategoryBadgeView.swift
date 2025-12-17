//
//  CategoryBadgeView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import SwiftUI

// MARK: - Componentes Auxiliares
struct CategoryBadgeView: View {
    let category: TravelDestination.TravelCategory
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: categoryIcon)
                .font(.caption2)
            
            Text(category.rawValue)
                .font(.caption2)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(categoryColor.opacity(0.15))
        .foregroundStyle(categoryColor)
        .clipShape(Capsule())
    }
    
    private var categoryColor: Color {
        switch category {
        case .adventure: return .green
        case .relax: return .blue
        case .business: return .purple
        case .family: return .orange
        case .solo: return .pink
        }
    }
    
    private var categoryIcon: String {
        switch category {
        case .adventure: return "mountain.2.fill"
        case .relax: return "beach.umbrella.fill"
        case .business: return "briefcase.fill"
        case .family: return "figure.2.and.child.holdinghands"
        case .solo: return "figure.walk"
        }
    }
}

#Preview {
    CategoryBadgeView(category: .relax)
}
