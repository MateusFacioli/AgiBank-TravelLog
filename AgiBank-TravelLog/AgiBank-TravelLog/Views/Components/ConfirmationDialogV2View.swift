//
//  ConfirmationDialogV2View.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct ConfirmationDialogV2View: View {
    @State private var mostrarDialogo = false
    @State private var acaoSelecionada: Acao?
    @State private var itemSelecionado: ItemTransacao?
    
    // Enum para organizar as ações (Type-safe)
    enum Acao {
        case visualizarDetalhes
        case editar
        case compartilhar
        case favoritar
        case duplicar
        case bloquear
        case excluir
        case relatorio
    }
    
    // Modelo de dados para exemplo
    struct ItemTransacao: Identifiable {
        let id = UUID()
        let titulo: String
        let descricao: String
        let valor: Double
        let data: Date
        let icone: String
        let cor: Color
    }
    
    // Dados de exemplo
    let transacoes: [ItemTransacao] = [
        ItemTransacao(
            titulo: "Supermercado",
            descricao: "Compra semanal",
            valor: -250.75,
            data: Date().addingTimeInterval(-86400),
            icone: "cart.fill",
            cor: .blue
        ),
        ItemTransacao(
            titulo: "Salário",
            descricao: "Pagamento empresa",
            valor: 3500.00,
            data: Date().addingTimeInterval(-172800),
            icone: "dollarsign.circle.fill",
            cor: .green
        ),
        ItemTransacao(
            titulo: "Restaurante",
            descricao: "Jantar com amigos",
            valor: -120.50,
            data: Date().addingTimeInterval(-43200),
            icone: "fork.knife",
            cor: .orange
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Cabeçalho informativo
            VStack(spacing: 8) {
                Text("ConfirmationDialog com Enum")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Organização com type safety e código limpo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            
            // Lista de transações
            List {
                Section(header: Text("Transações Recentes").font(.headline)) {
                    ForEach(transacoes) { transacao in
                        linhaTransacao(transacao)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                // Swipe para excluir
                                Button(role: .destructive) {
                                    itemSelecionado = transacao
                                    acaoSelecionada = .excluir
                                    mostrarDialogo = true
                                } label: {
                                    Label("Excluir", systemImage: "trash")
                                }
                                
                                // Swipe para editar
                                Button {
                                    itemSelecionado = transacao
                                    acaoSelecionada = .editar
                                    executarAcao()
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                            .swipeActions(edge: .leading) {
                                // Swipe para favoritar
                                Button {
                                    itemSelecionado = transacao
                                    acaoSelecionada = .favoritar
                                    executarAcao()
                                } label: {
                                    Label("Favoritar", systemImage: "star")
                                }
                                .tint(.yellow)
                            }
                            .contextMenu {
                                menuContextual(transacao)
                            }
                    }
                }
                
                Section(header: Text("Ações Rápidas").font(.headline)) {
                    Button {
                        acaoSelecionada = .relatorio
                        executarAcao()
                    } label: {
                        Label("Gerar Relatório Mensal", systemImage: "chart.bar.doc.horizontal")
                    }
                    
                    Button {
                        acaoSelecionada = .duplicar
                        executarAcao()
                    } label: {
                        Label("Duplicar Transações", systemImage: "doc.on.doc")
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("ConfirmationDialog V2")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            dialogTitle,
            isPresented: $mostrarDialogo,
            titleVisibility: .visible
        ) {
            botoesDialogo
        } message: {
            if let item = itemSelecionado {
                Text("\(item.titulo): R$ \(abs(item.valor), specifier: "%.2f")")
                    .fontWeight(.medium)
            }
        }
        .onChange(of: acaoSelecionada) { oldValue, newValue in
            if newValue != nil && itemSelecionado != nil {
                mostrarDialogo = true
            }
        }
    }
    
    // MARK: - Componentes Reutilizáveis
    
    private func linhaTransacao(_ transacao: ItemTransacao) -> some View {
        HStack(spacing: 15) {
            // Ícone da transação
            Circle()
                .fill(transacao.cor.opacity(0.2))
                .frame(width: 45, height: 45)
                .overlay {
                    Image(systemName: transacao.icone)
                        .foregroundColor(transacao.cor)
                        .font(.title3)
                }
            
            // Informações da transação
            VStack(alignment: .leading, spacing: 4) {
                Text(transacao.titulo)
                    .font(.headline)
                
                Text(transacao.descricao)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(transacao.data.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Valor da transação
            Text("R$ \(transacao.valor, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(transacao.valor > 0 ? .green : .red)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            itemSelecionado = transacao
            acaoSelecionada = .visualizarDetalhes
            executarAcao()
        }
    }
    
    private func menuContextual(_ transacao: ItemTransacao) -> some View {
        Group {
            Button {
                itemSelecionado = transacao
                acaoSelecionada = .visualizarDetalhes
                executarAcao()
            } label: {
                Label("Ver Detalhes", systemImage: "doc.text.magnifyingglass")
            }
            
            Button {
                itemSelecionado = transacao
                acaoSelecionada = .compartilhar
                executarAcao()
            } label: {
                Label("Compartilhar", systemImage: "square.and.arrow.up")
            }
            
            Button {
                itemSelecionado = transacao
                acaoSelecionada = .favoritar
                executarAcao()
            } label: {
                Label("Favoritar", systemImage: "star")
            }
            
            Divider()
            
            Button(role: .destructive) {
                itemSelecionado = transacao
                acaoSelecionada = .excluir
                mostrarDialogo = true
            } label: {
                Label("Excluir", systemImage: "trash")
            }
        }
    }
    
    private var dialogTitle: String {
        guard let item = itemSelecionado else { return "Selecione uma ação" }
        return "\(item.titulo)"
    }
    
    private var botoesDialogo: some View {
        Group {
            Button("📊 Visualizar Detalhes") {
                acaoSelecionada = .visualizarDetalhes
                executarAcao()
            }
            
            Button("✏️ Editar") {
                acaoSelecionada = .editar
                executarAcao()
            }
            
            Button("📤 Compartilhar") {
                acaoSelecionada = .compartilhar
                executarAcao()
            }
            
            Button("📋 Duplicar") {
                acaoSelecionada = .duplicar
                executarAcao()
            }
            
            Button("🚫 Bloquear", role: .destructive) {
                acaoSelecionada = .bloquear
                executarAcao()
            }
            
            Button("🗑️ Excluir", role: .destructive) {
                acaoSelecionada = .excluir
                executarAcao()
            }
            
            Button("❌ Cancelar", role: .cancel) {
                limparSelecao()
            }
        }
    }
    
    // MARK: - Lógica de Ações
    
    private func executarAcao() {
        guard let acao = acaoSelecionada else { return }
        
        switch acao {
        case .visualizarDetalhes:
            if let item = itemSelecionado {
                print("📱 Visualizando detalhes: \(item.titulo)")
            }
            
        case .editar:
            if let item = itemSelecionado {
                print("✏️ Editando: \(item.titulo)")
            }
            
        case .compartilhar:
            if let item = itemSelecionado {
                print("📤 Compartilhando: \(item.titulo)")
            }
            
        case .favoritar:
            if let item = itemSelecionado {
                print("⭐ Favoritando: \(item.titulo)")
            }
            
        case .duplicar:
            if let item = itemSelecionado {
                print("📋 Duplicando: \(item.titulo)")
            } else {
                print("📋 Duplicando todas as transações")
            }
            
        case .bloquear:
            if let item = itemSelecionado {
                print("🚫 Bloqueando: \(item.titulo)")
            }
            
        case .excluir:
            if let item = itemSelecionado {
                print("🗑️ Excluindo: \(item.titulo)")
            }
            
        case .relatorio:
            print("📊 Gerando relatório mensal")
        }
        
        limparSelecao()
    }
    
    private func limparSelecao() {
        acaoSelecionada = nil
        itemSelecionado = nil
    }
}
