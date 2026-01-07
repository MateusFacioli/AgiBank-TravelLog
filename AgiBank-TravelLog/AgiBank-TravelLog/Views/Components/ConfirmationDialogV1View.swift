//
//  ConfirmationDialogV1View.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct ConfirmationDialogV1View: View {
    @State private var mostrarConfirmationDialog = false
    @State private var mostrarContextMenu = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("ConfirmationDialog Básico")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Substituto moderno do ActionSheet")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Exemplo 1: Botão para mostrar diálogo
            Button {
                mostrarConfirmationDialog = true
            } label: {
                Label("Mostrar Opções", systemImage: "ellipsis.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            
            // Exemplo 2: Card interativo
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "creditcard.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("Cartão Final 1234")
                            .font(.headline)
                        Text("Limite: R$ 5.000,00")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                HStack {
                    Button("Gerenciar Cartão") {
                        mostrarConfirmationDialog = true
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Text("Ativo")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            .contextMenu {
                Button {
                    print("📤 Compartilhar cartão")
                } label: {
                    Label("Compartilhar", systemImage: "square.and.arrow.up")
                }
                
                Button {
                    print("⭐ Favoritar cartão")
                } label: {
                    Label("Favoritar", systemImage: "star")
                }
                
                Divider()
                
                Button(role: .destructive) {
                    print("🔒 Bloquear cartão")
                } label: {
                    Label("Bloquear", systemImage: "lock")
                }
            }
            
            Spacer()
        }
        .padding(.vertical)
        .navigationTitle("ConfirmationDialog V1")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Gerenciar Cartão",
            isPresented: $mostrarConfirmationDialog,
            titleVisibility: .visible
        ) {
            Button("Visualizar Extrato") {
                print("📊 Visualizando extrato")
            }
            
            Button("Alterar Limite") {
                print("💰 Alterando limite")
            }
            
            Button("Configurações") {
                print("⚙️ Acessando configurações")
            }
            
            Button("Bloquear Temporariamente", role: .destructive) {
                print("🚫 Cartão bloqueado")
            }
            
            Button("Excluir Cartão", role: .destructive) {
                print("🗑️ Cartão excluído")
            }
            
            Button("Cancelar", role: .cancel) {
                print("❌ Ação cancelada")
            }
        } message: {
            Text("Escolha uma ação para gerenciar seu cartão de crédito")
        }
    }
}
