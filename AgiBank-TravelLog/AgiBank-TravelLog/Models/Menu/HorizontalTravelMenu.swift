//
//  HorizontalTravelMenu.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import SwiftUI

struct HorizontalTravelMenu: View {
    @Binding var selectedCategory: MenuItem.MenuCategory
    @State private var scrollPosition: MenuItem.ID?
    
    private let menuItems: [MenuItem]
    var onCategorySelected: ((MenuItem.MenuCategory) -> Void)?
    
    init(
        selectedCategory: Binding<MenuItem.MenuCategory>,
        onCategorySelected: ((MenuItem.MenuCategory) -> Void)? = nil
    ) {
        self._selectedCategory = selectedCategory
        self.onCategorySelected = onCategorySelected
        self.menuItems = MenuItem.menuWithSelected(selectedCategory.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // ScrollView horizontal com scrollPosition para controle programático
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { proxy in
                    HStack(spacing: 12) {
                        ForEach(menuItems) { item in
                            MenuItemView(
                                item: item,
                                isSelected: item.category == selectedCategory
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedCategory = item.category
                                    scrollPosition = item.id
                                    onCategorySelected?(item.category)
                                }
                            }
                            .id(item.id)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .onChange(of: scrollPosition) { _, newValue in
                        if let newValue = newValue {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                    }
                    .onChange(of: selectedCategory) { _, newCategory in
                        // Atualiza scroll position quando a categoria muda externamente
                        if let item = menuItems.first(where: { $0.category == newCategory }) {
                            scrollPosition = item.id
                        }
                    }
                }
            }
            .background(.ultraThinMaterial)
            
            // Indicador de seleção
            Rectangle()
                .fill(Color.accentColor)
                .frame(height: 3)
                .frame(width: indicatorWidth)
                .offset(x: indicatorOffset)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedCategory)
        }
        .background {
            // Efeito de blur no fundo
            RoundedRectangle(cornerRadius: 0)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
        }
    }
    
    private var indicatorWidth: CGFloat {
        // Calcula a largura baseada no título da categoria selecionada
        let text = selectedCategory.title
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return max(80, size.width + 32) // Mínimo 80, mais padding
    }
    
    private var indicatorOffset: CGFloat {
        guard let selectedIndex = menuItems.firstIndex(where: { $0.category == selectedCategory }) else {
            return 0
        }
        
        // Calcula a posição baseada no índice selecionado
        let itemWidth: CGFloat = 80 // Largura fixa de cada item
        let spacing: CGFloat = 12
        let totalItems = menuItems.count
        let totalWidth = CGFloat(totalItems) * itemWidth + CGFloat(totalItems - 1) * spacing
        let startPosition = -totalWidth / 2 + itemWidth / 2
        
        return startPosition + CGFloat(selectedIndex) * (itemWidth + spacing)
    }
}
