//
//  EnvironmentObjectView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

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
