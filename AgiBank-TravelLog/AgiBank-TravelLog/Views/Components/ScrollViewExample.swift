//
//  ScrollViewExample.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct ScrollViewExample: View {
    @State private var showScrollIndicator = true
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Cabeçalho
                    VStack(spacing: 10) {
                        Text("📜 ScrollView")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Rolagem vertical e horizontal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    .id("top")
                    
                    // ScrollView Vertical (Padrão)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("ScrollView Vertical")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        ForEach(1...20, id: \.self) { index in
                            ScrollCardView(index: index, color: .blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // ScrollView Horizontal
                    VStack(alignment: .leading, spacing: 15) {
                        Text("ScrollView Horizontal")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        ScrollView(.horizontal, showsIndicators: showScrollIndicator) {
                            HStack(spacing: 15) {
                                ForEach(1...10, id: \.self) { index in
                                    HorizontalCardView(index: index, color: .green)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Controles
                    VStack(spacing: 15) {
                        Text("Controles")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        Toggle("Mostrar Indicadores", isOn: $showScrollIndicator)
                            .toggleStyle(.switch)
                        
                        HStack(spacing: 15) {
                            Button("Ir para Topo") {
                                withAnimation {
                                    proxy.scrollTo("top", anchor: .top)
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Ir para Item 50") {
                                withAnimation {
                                    proxy.scrollTo(50, anchor: .center)
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Ir para Final") {
                                withAnimation {
                                    proxy.scrollTo("bottom")
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    
                    // Mais conteúdo para scroll
                    ForEach(21...50, id: \.self) { index in
                        ScrollCardView(index: index, color: .gray)
                            .id(index)
                    }
                    
                    // Rodapé
                    Text("Fim do conteúdo")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                        .id("bottom")
                }
                .padding()
            }
        }
        .navigationTitle("ScrollView")
        .navigationBarTitleDisplayMode(.inline)
    }
}
