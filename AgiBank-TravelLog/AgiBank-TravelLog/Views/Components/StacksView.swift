//
//  StacksView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct StacksView: View {
    @State private var stackSpacing: CGFloat = 20
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Stacks em SwiftUI")
                    .font(.title)
                    .fontWeight(.bold)
                
                // VStack (Vertical)
                VStack(alignment: .leading, spacing: stackSpacing) {
                    Text("VStack (Vertical)")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    ForEach(1...3, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.blue.opacity(0.2))
                            .frame(height: 60)
                            .overlay {
                                Text("Item \(index)")
                                    .fontWeight(.medium)
                            }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                
                // HStack (Horizontal)
                HStack(spacing: stackSpacing) {
                    Text("HStack")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    ForEach(1...3, id: \.self) { index in
                        Circle()
                            .fill(.green.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay {
                                Text("\(index)")
                                    .fontWeight(.bold)
                            }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                
                // ZStack (Overlay)
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.purple.opacity(0.2))
                        .frame(height: 150)
                    
                    Circle()
                        .fill(.purple.opacity(0.4))
                        .frame(width: 80, height: 80)
                    
                    Text("ZStack")
                        .font(.headline)
                        .foregroundColor(.purple)
                        .offset(y: -40)
                    
                    Text("Camadas sobrepostas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .offset(y: 30)
                }
                .padding(.horizontal)
                
                // Stack Combinados
                VStack(spacing: 15) {
                    Text("Stacks Combinados")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    HStack(spacing: 10) {
                        ForEach(1...2, id: \.self) { col in
                            VStack(spacing: 10) {
                                ForEach(1...3, id: \.self) { row in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.orange.opacity(0.2))
                                        .frame(height: 40)
                                        .overlay {
                                            Text("\(col)-\(row)")
                                                .font(.caption)
                                        }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                
                // Spacer e Divider
                VStack(spacing: 20) {
                    Text("Spacer & Divider")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    HStack {
                        Text("Esquerda")
                        Spacer()
                        Text("Centro")
                        Spacer()
                        Text("Direita")
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                    
                    Divider()
                        .background(Color.red)
                        .padding(.horizontal)
                    
                    HStack {
                        Rectangle()
                            .fill(.red.opacity(0.3))
                            .frame(height: 50)
                        
                        Spacer(minLength: 20)
                        
                        Rectangle()
                            .fill(.red.opacity(0.3))
                            .frame(height: 50)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                
                // Configuração do Spacing
                VStack(spacing: 15) {
                    Text("Configurar Spacing: \(Int(stackSpacing))")
                        .font(.headline)
                    
                    Slider(value: $stackSpacing, in: 0...50, step: 5) {
                        Text("Espaçamento")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("50")
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
            }
            .padding()
        }
        .navigationTitle("Stacks")
        .navigationBarTitleDisplayMode(.inline)
    }
}
