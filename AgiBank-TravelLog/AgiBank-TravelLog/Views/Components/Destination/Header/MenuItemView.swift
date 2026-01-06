//
//  MenuItemView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

/**
 Item visual de menu que exibe ícone e título de uma opção, com destaque para o estado selecionado.
 
 - Usa `symbolEffect` para dar feedback sutil quando selecionado.
 - Ajusta cor e fundo (círculo) conforme `isSelected`.
 */

import SwiftUI

/// Componente de item de menu horizontal/compacto usado em listas de categorias e filtros.
struct MenuItemView: View {
    /// Dados do item (ícone e título) a serem exibidos.
    let item: MenuItem
    /// Indica se o item está selecionado, influenciando estilo e animação do ícone.
    let isSelected: Bool
    
    /// Layout vertical com ícone e rótulo, aplicando destaque visual quando selecionado.
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: item.icon)
                .font(.system(size: 20, weight: .medium))
                .symbolEffect(.bounce, value: isSelected)
                .frame(width: 44, height: 44)
                .background {
                    if isSelected {
                        Circle()
                            .fill(Color.accentColor.opacity(0.15))
                    }
                }
            
            Text(item.title)
                .font(.system(size: 12, weight: .medium))
                .lineLimit(1)
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundStyle(isSelected ? Color.accentColor : .secondary)
        .frame(width: 80)
        .contentShape(Rectangle())
    }
}

/// Conjunto de Previews demonstrando o uso do `MenuItemView` em diferentes menus.
#Preview {
    VStack(spacing: 30) {
        // Menu padrão
        Text("Menu de Viagens")
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
        HorizontalTravelMenu(selectedCategory: .constant(.myTrips))
            .frame(height: 120)
        
        Divider()
            .padding(.horizontal)
        
        // Menu compacto - CRIADO LOCALMENTE
        Text("Menu Compacto")
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
        // Criação de um CompactTravelMenu local para o preview
        CompactTravelMenuPreview()
            .frame(height: 60)
        
        Divider()
            .padding(.horizontal)
        
        // Menu com filtros
        Text("Filtros")
            .font(.title2.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
        // Criação de um FilterableTravelMenu para o preview
        FilterableTravelMenuPreview()
            .frame(height: 60)
    }
    .padding(.vertical)
}

