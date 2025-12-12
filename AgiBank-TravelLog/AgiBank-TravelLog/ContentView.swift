//
//  ContentView.swift
//  AgiBank-Theory
//
//  Created by Mateus Rodrigues on 10/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("📐 Layouts e Containers") {
                    NavigationLink("📱 Stacks", destination: StacksView())
                    NavigationLink("📜 ScrollView", destination: ScrollViewExample())
                    NavigationLink("📋 List", destination: ListView())
                }
                
                Section("Componentes Básicos") {
                    NavigationLink("📝 TextField", destination: TextFieldView())
                    NavigationLink("🎯 Picker", destination: PickerView())
                    NavigationLink("📅 DatePicker", destination: DatePickerView())
                    NavigationLink("📊 Slider e Stepper", destination: SliderStepperView())
                    NavigationLink("🔘 Toggle", destination: ToggleView())
                }
                
                Section("Alertas e Diálogos") {
                    NavigationLink("⚠️ Alert", destination: AlertView())
                    NavigationLink("🗂️ ConfirmationDialog V1", destination: ConfirmationDialogV1View())
                    NavigationLink("🧩 ConfirmationDialog V2 com Enum", destination: ConfirmationDialogV2View())
                }
                
                Section("Gerenciamento de Estado") {
                    NavigationLink("📌 @State", destination: StateView())
                    NavigationLink("🔗 @Binding", destination: BindingView())
                    NavigationLink("🔄 @ObservedObject", destination: ObservedObjectView())
                    NavigationLink("🏛️ @StateObject", destination: StateObjectView())
                    NavigationLink("🌐 @EnvironmentObject", destination: EnvironmentObjectView())
                }
            }
            .navigationTitle("AgiBank Theory")
        }
    }
}

// MARK: - Layouts e Containers

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

struct ScrollCardView: View {
    let index: Int
    let color: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay {
                    Text("\(index)")
                        .fontWeight(.bold)
                }
            
            VStack(alignment: .leading) {
                Text("Item \(index)")
                    .font(.headline)
                Text("Descrição do item \(index)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .id(index)
    }
}

struct HorizontalCardView: View {
    let index: Int
    let color: Color
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.2))
                .frame(width: 120, height: 120)
                .overlay {
                    VStack {
                        Text("Item")
                            .font(.caption)
                        Text("\(index)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
            
            Text("Card \(index)")
                .font(.caption)
                .padding(.top, 5)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ListView: View {
    @State private var items = Array(1...20).map { "Item \($0)" }
    @State private var selectedItems: Set<String> = []
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        List(selection: $selectedItems) {
            Section("Lista Simples") {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .swipeActions {
                            Button(role: .destructive) {
                                deleteItem(item)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                            
                            Button {
                                duplicateItem(item)
                            } label: {
                                Label("Duplicar", systemImage: "doc.on.doc")
                            }
                            .tint(.blue)
                        }
                }
            }
            
            Section("Lista com Ações") {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(item)
                        
                        Spacer()
                        
                        if selectedItems.contains(item) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedItems.contains(item) {
                            selectedItems.remove(item)
                        } else {
                            selectedItems.insert(item)
                        }
                    }
                }
            }
            
            Section("Lista Dinâmica") {
                ForEach($items, id: \.self) { $item in
                    TextField("Editar item", text: $item)
                        .textFieldStyle(.roundedBorder)
                }
                .onDelete { indexSet in
                    items.remove(atOffsets: indexSet)
                }
                .onMove { indices, newOffset in
                    items.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            
            Section("List Styles") {
                Text("Inset Grouped (Este estilo)")
                    .listRowBackground(Color.blue.opacity(0.1))
                
                Text("Plain")
                    .listRowBackground(Color.green.opacity(0.1))
                
                Text("Sidebar")
                    .listRowBackground(Color.orange.opacity(0.1))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Adicionar") {
                    addItem()
                }
            }
        }
        .environment(\.editMode, $editMode)
    }
    
    private func addItem() {
        let newItem = "Item \(items.count + 1)"
        items.append(newItem)
    }
    
    private func deleteItem(_ item: String) {
        items.removeAll { $0 == item }
    }
    
    private func duplicateItem(_ item: String) {
        items.append("\(item) (cópia)")
    }
}

// MARK: - Componentes Básicos (Mantidos)

struct TextFieldView: View {
    @State private var nome = ""
    @State private var email = ""
    @State private var telefone = ""
    @State private var senha = ""
    
    var body: some View {
        Form {
            Section("Exemplos de TextField") {
                TextField("Digite seu nome", text: $nome)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: email) { oldValue, newValue in
                        print("Email alterado: \(newValue)")
                    }
                
                TextField("Telefone", text: $telefone)
                    .keyboardType(.phonePad)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Senha", text: $senha)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Decimal", text: .constant(""))
                    .keyboardType(.decimalPad)
            }
            
            Section("Valores Atuais") {
                Text("Nome: \(nome)")
                Text("Email: \(email)")
                Text("Telefone: \(telefone)")
                Text("Senha: \(senha.isEmpty ? "Não informada" : "••••••")")
            }
        }
        .navigationTitle("TextField")
    }
}

struct PickerView: View {
    @State private var selecionado = 0
    @State private var filtro = "0"
    @State private var corSelecionada = "Vermelho"
    
    let cores = ["Vermelho", "Verde", "Azul", "Amarelo"]
    
    var body: some View {
        Form {
            Section("Picker Menu") {
                Picker("Selecione uma opção", selection: $selecionado) {
                    Text("Opção 1").tag(0)
                    Text("Opção 2").tag(1)
                    Text("Opção 3").tag(2)
                }
                .pickerStyle(.menu)
                
                Text("Opção selecionada: \(selecionado + 1)")
            }
            
            Section("Picker Segmented") {
                Picker("Filtro", selection: $filtro) {
                    Text("Todos").tag("0")
                    Text("Ativos").tag("1")
                    Text("Inativos").tag("2")
                }
                .pickerStyle(.segmented)
                
                Text("Filtro: \(filtro == "0" ? "Todos" : filtro == "1" ? "Ativos" : "Inativos")")
            }
            
            Section("Wheel Picker") {
                Picker("Cor", selection: $corSelecionada) {
                    ForEach(cores, id: \.self) { cor in
                        Text(cor)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
            }
        }
        .navigationTitle("Picker")
    }
}

struct DatePickerView: View {
    @State private var data = Date()
    @State private var hora = Date()
    @State private var dataCompleta = Date()
    
    var body: some View {
        Form {
            Section("DatePicker - Data") {
                DatePicker("Data de Nascimento",
                          selection: $data,
                          displayedComponents: .date)
                
                Text("Data selecionada: \(data.formatted(date: .long, time: .omitted))")
            }
            
            Section("DatePicker - Hora") {
                DatePicker("Horário",
                          selection: $hora,
                          displayedComponents: .hourAndMinute)
                
                Text("Hora selecionada: \(hora.formatted(date: .omitted, time: .shortened))")
            }
            
            Section("DatePicker - Data e Hora") {
                DatePicker("Data e Hora",
                          selection: $dataCompleta,
                          displayedComponents: [.date, .hourAndMinute])
                
                Text("Data completa: \(dataCompleta.formatted())")
            }
            
            Section("DatePicker com Range") {
                DatePicker("Data Limite",
                          selection: $data,
                          in: Date()...Date().addingTimeInterval(86400 * 30),
                          displayedComponents: .date)
            }
        }
        .navigationTitle("DatePicker")
    }
}

struct SliderStepperView: View {
    @State private var valor = 0.5
    @State private var quantidade = 1
    @State private var idade = 18
    @State private var porcentagem = 50.0
    
    var body: some View {
        Form {
            Section("Slider Básico") {
                Slider(value: $valor, in: 0...1)
                Text("Valor: \(valor, specifier: "%.2f")")
            }
            
            Section("Slider com Step") {
                Slider(value: $porcentagem, in: 0...100, step: 5)
                Text("Porcentagem: \(Int(porcentagem))%")
            }
            
            Section("Slider com Labels") {
                Slider(value: $valor, in: 0...1) {
                    Text("Intensidade")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("1")
                }
            }
            
            Section("Stepper Básico") {
                Stepper("Quantidade: \(quantidade)",
                       value: $quantidade,
                       in: 1...10)
                
                Stepper("", value: $quantidade)
                    .labelsHidden()
            }
            
            Section("Stepper com Formatação") {
                Stepper(value: $idade, in: 0...120, step: 1) {
                    Text("Idade: \(idade) anos")
                }
            }
        }
        .navigationTitle("Slider & Stepper")
    }
}

struct ToggleView: View {
    @State private var notificacoes = true
    @State private var modoEscuro = false
    @State private var wifi = true
    @State private var bluetooth = false
    
    var body: some View {
        Form {
            Section("Configurações") {
                Toggle("Receber notificações", isOn: $notificacoes)
                    .toggleStyle(.switch)
                
                Toggle("Modo Escuro", isOn: $modoEscuro)
                    .toggleStyle(.switch)
                
                Toggle("Wi-Fi", isOn: $wifi)
                    .toggleStyle(.switch)
                
                Toggle("Bluetooth", isOn: $bluetooth)
                    .toggleStyle(.switch)
            }
            
            Section("Status") {
                Label("Notificações: \(notificacoes ? "Ativadas" : "Desativadas")",
                      systemImage: notificacoes ? "bell.fill" : "bell.slash")
                
                Label("Tema: \(modoEscuro ? "Escuro" : "Claro")",
                      systemImage: modoEscuro ? "moon.fill" : "sun.max.fill")
                
                Label("Conexão Wi-Fi: \(wifi ? "Conectado" : "Desconectado")",
                      systemImage: wifi ? "wifi" : "wifi.slash")
                
                Label("Bluetooth: \(bluetooth ? "Ativo" : "Inativo")",
                      systemImage: bluetooth ? "dot.radiowaves.left.and.right" : "dot.radiowaves.right")
            }
            
            Section("Toggle Styles") {
                Toggle("Botão", isOn: $notificacoes)
                    .toggleStyle(.button)
            }
        }
        .navigationTitle("Toggle")
    }
}

// MARK: - Alertas e Diálogos (Mantidos)

struct AlertView: View {
    @State private var mostrarAlert = false
    @State private var mostrarAlertPersonalizado = false
    @State private var language = "SwiftUI"
    @State private var contador = 0
    
    var body: some View {
        Form {
            Section("Alert Básico") {
                Button("Mostrar Alert Simples") {
                    mostrarAlert = true
                }
                .alert("Atenção!", isPresented: $mostrarAlert) {
                    Button("OK") { }
                } message: {
                    Text("Esta é uma mensagem de alerta básica.")
                }
            }
            
            Section("Alert com Múltiplas Opções") {
                Button("Estou aprendendo \(language)") {
                    mostrarAlertPersonalizado = true
                }
                .alert("🎉 Parabéns!", isPresented: $mostrarAlertPersonalizado) {
                    Button("Continuar Estudando") {
                        print("Continuar pressionado")
                    }
                    Button("Ver Projetos", role: .none) {
                        print("Ver projetos pressionado")
                    }
                    Button("Cancelar", role: .cancel) {
                        print("Cancelar pressionado")
                    }
                    Button("Deletar Progresso", role: .destructive) {
                        print("Deletar pressionado")
                        contador = 0
                    }
                } message: {
                    Text("Você está no caminho certo para dominar o \(language)!")
                }
            }
            
            Section("Alert com TextField") {
                Button("Alterar Linguagem") {
                    // Implementação com TextField no alert
                }
            }
            
            Section("Exemplo Prático") {
                HStack {
                    Text("Contador: \(contador)")
                    Spacer()
                    Button("Incrementar") {
                        contador += 1
                        if contador >= 5 {
                            mostrarAlert = true
                        }
                    }
                }
            }
        }
        .navigationTitle("Alert")
    }
}

// MARK: - ConfirmationDialog V1 (Básico) - Mantido
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

// MARK: - ConfirmationDialog V2 (com Enum) - Mantido
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

// MARK: - Gerenciamento de Estado (Mantidos)

struct StateView: View {
    @State private var count = 0
    @State private var texto = ""
    @State private var ligado = false
    
    var body: some View {
        Form {
            Section("Exemplo de @State") {
                Text("@State é usado para propriedades que pertencem a uma única view")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Contador: \(count)")
                        Spacer()
                        Button("Incrementar") {
                            count += 1
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    TextField("Digite algo", text: $texto)
                        .textFieldStyle(.roundedBorder)
                    
                    Toggle("Ativar", isOn: $ligado)
                        .toggleStyle(.switch)
                    
                    Text("Texto digitado: \(texto)")
                    Text("Toggle: \(ligado ? "Ligado" : "Desligado")")
                }
            }
            
            Section("Características do @State") {
                Label("Privado à View", systemImage: "lock.fill")
                Label("Source of Truth", systemImage: "checkmark.circle.fill")
                Label("SwiftUI gerencia a memória", systemImage: "memorychip")
                Label("Reinicia ao recriar a View", systemImage: "arrow.clockwise")
            }
        }
        .navigationTitle("@State")
    }
}

struct BindingView: View {
    @State private var textoPai = ""
    
    var body: some View {
        Form {
            Section("Explicação") {
                Text("@Binding cria uma conexão bidirecional entre views")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("View Pai") {
                TextField("Digite no pai", text: $textoPai)
                    .textFieldStyle(.roundedBorder)
                
                Text("Valor no pai: \(textoPai)")
            }
            
            Section("View Filha") {
                ChildView(texto: $textoPai)
            }
        }
        .navigationTitle("@Binding")
    }
}

struct ChildView: View {
    @Binding var texto: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("View Filha (ChildView)")
                .font(.headline)
            
            TextField("Digite na filha", text: $texto)
                .textFieldStyle(.roundedBorder)
            
            Text("Valor na filha: \(texto)")
                .font(.caption)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// ViewModel para exemplo de ObservedObject
class UserViewModel: ObservableObject {
    @Published var nome = ""
    @Published var email = ""
    @Published var isLoggedIn = false
    
    func login() {
        if !nome.isEmpty && !email.isEmpty {
            isLoggedIn = true
            print("Usuário \(nome) logado com sucesso!")
        }
    }
    
    func logout() {
        isLoggedIn = false
        nome = ""
        email = ""
        print("Usuário deslogado")
    }
}

struct ObservedObjectView: View {
    @ObservedObject var viewModel = UserViewModel()
    
    var body: some View {
        Form {
            Section("Explicação") {
                Text("@ObservedObject observa um objeto que implementa ObservableObject")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("Dados do Usuário") {
                TextField("Nome", text: $viewModel.nome)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
            }
            
            Section("Status") {
                Label(viewModel.isLoggedIn ? "Logado" : "Deslogado",
                      systemImage: viewModel.isLoggedIn ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(viewModel.isLoggedIn ? .green : .red)
            }
            
            Section("Ações") {
                Button(viewModel.isLoggedIn ? "Logout" : "Login") {
                    if viewModel.isLoggedIn {
                        viewModel.logout()
                    } else {
                        viewModel.login()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isLoggedIn && (viewModel.nome.isEmpty || viewModel.email.isEmpty))
            }
            
            Section("Detalhes Técnicos") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("• ViewModel é criado pela própria view")
                    Text("• Pode ser reinicializado pelo SwiftUI")
                    Text("• Usado quando a view não é dona dos dados")
                    Text("• Ideal para views que recebem ViewModel externo")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .navigationTitle("@ObservedObject")
    }
}

struct StateObjectView: View {
    @StateObject var viewModel = UserViewModel()
    
    var body: some View {
        Form {
            Section("Explicação") {
                Text("@StateObject cria e mantém a propriedade durante o ciclo de vida da view")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("Comparação com @ObservedObject") {
                VStack(alignment: .leading, spacing: 8) {
                    Label("@StateObject: View é dona", systemImage: "person.fill.checkmark")
                    Label("@ObservedObject: View observa", systemImage: "eye.fill")
                    Label("@StateObject: Persiste em redraws", systemImage: "arrow.clockwise")
                    Label("@ObservedObject: Pode ser reinicializado", systemImage: "arrow.triangle.2.circlepath")
                }
                .font(.caption)
            }
            
            Section("Exemplo Prático") {
                VStack(spacing: 15) {
                    Text("StateObject garante que o ViewModel")
                    Text("não seja recriado quando a view atualizar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Contador de instâncias:")
                        Spacer()
                        Text("\(viewModel.nome.count)")
                            .font(.headline)
                    }
                    
                    Button("Atualizar View (Simular)") {
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            
            Section("Quando Usar") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("✅ Use @StateObject quando:")
                    Text("  • View é dona dos dados")
                    Text("  • Criando ViewModel na view")
                    Text("  • Dados devem persistir")
                    
                    Text("\n✅ Use @ObservedObject quando:")
                    Text("  • Recebendo ViewModel de fora")
                    Text("  • View não é dona dos dados")
                    Text("  • Dados são compartilhados")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .navigationTitle("@StateObject")
    }
}

// AppState para EnvironmentObject
class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userName = ""
    @Published var theme = "Claro"
}

struct EnvironmentObjectView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Form {
            Section("Explicação") {
                Text("@EnvironmentObject injeta objetos na hierarquia de views")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("Estado Global") {
                HStack {
                    Text("Logado:")
                    Spacer()
                    Text(appState.isLoggedIn ? "Sim" : "Não")
                        .foregroundColor(appState.isLoggedIn ? .green : .red)
                }
                
                HStack {
                    Text("Usuário:")
                    Spacer()
                    Text(appState.userName.isEmpty ? "Não definido" : appState.userName)
                }
                
                HStack {
                    Text("Tema:")
                    Spacer()
                    Text(appState.theme)
                }
            }
            
            Section("Ações") {
                Button(appState.isLoggedIn ? "Logout" : "Login") {
                    appState.isLoggedIn.toggle()
                    if appState.isLoggedIn {
                        appState.userName = "Usuário Demo"
                    } else {
                        appState.userName = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Alternar Tema") {
                    appState.theme = appState.theme == "Claro" ? "Escuro" : "Claro"
                }
                .buttonStyle(.bordered)
            }
            
            Section("Hierarquia de Views") {
                NavigationLink("Ir para Tela 2", destination: EnvironmentChildView())
                NavigationLink("Ir para Tela 3", destination: EnvironmentGrandChildView())
            }
            
            Section("Vantagens") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("✅ Evita prop drilling")
                    Text("✅ Compartilhamento fácil")
                    Text("✅ Atualiza todas as views")
                    Text("✅ Injeção automática")
                    
                    Text("\n⚠️ Cuidados:")
                    Text("• Não usar em excesso")
                    Text("• Pode dificultar debug")
                    Text("• Testes mais complexos")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .navigationTitle("@EnvironmentObject")
    }
}

struct EnvironmentChildView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("View Filha")
                .font(.title2)
            
            Text("Acessando EnvironmentObject")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Usuário: \(appState.userName)")
                Text("Tema: \(appState.theme)")
                Text("Logado: \(appState.isLoggedIn ? "Sim" : "Não")")
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("View Filha")
    }
}

struct EnvironmentGrandChildView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            Text("View Neto")
                .font(.title2)
            
            Text("Mesmo EnvironmentObject")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Alterar Tema Aqui") {
                appState.theme = appState.theme == "Claro" ? "Escuro" : "Claro"
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .navigationTitle("View Neto")
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
