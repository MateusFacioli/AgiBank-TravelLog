//
//  CategoryBadgeView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

/**
 Exibe um selo (badge) para a categoria de um destino de viagem.
 
 - Mostra ícone e nome da categoria com estilo consistente (cápsula, cor temática e tipografia compacta).
 - Útil para destacar o tipo de viagem em listas, cards e detalhes do destino.
 */

import SwiftUI

/// Componente visual simples para representar a categoria de um destino com ícone e rótulo.
struct CategoryBadgeView: View {
    /// Categoria do destino usada para definir ícone, cor e rótulo exibidos.
    let category: TravelDestination.TravelCategory
    
    /// Layout do badge com ícone SF Symbol e texto, estilizados em uma cápsula colorida.
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
    
    /// Cor associada a cada categoria, usada no fundo e no `foregroundStyle` do badge.
    private var categoryColor: Color {
        switch category {
        case .adventure: return .green
        case .relax: return .blue
        case .business: return .purple
        case .family: return .orange
        case .solo: return .pink
        }
    }
    
    /// Nome do SF Symbol correspondente à categoria informada.
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

/// Preview do componente com a categoria `.relax`.
#Preview {
    CategoryBadgeView(category: .relax)
}
