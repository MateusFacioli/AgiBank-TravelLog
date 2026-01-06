//
//  EmptyStateMenuView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

/**
 View para exibir um estado vazio (Empty State) contextual para cada categoria do menu.
 
 - Mostra ícone, título e mensagem orientando a pessoa usuária quando não há conteúdo disponível.
 - Personaliza a apresentação com base em `MenuItem.MenuCategory` (ícone e textos).
 */

import SwiftUI

/// Componente de estado vazio que comunica ausência de itens para uma categoria específica do menu.
struct EmptyStateMenuView: View {
    /// Categoria do menu que define ícone, título e mensagem do estado vazio.
    let category: MenuItem.MenuCategory
    
    /// Layout vertical com ícone de destaque e textos explicativos centralizados.
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: category.icon)
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            Text(category.emptyStateTitle)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(category.emptyStateMessage)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
