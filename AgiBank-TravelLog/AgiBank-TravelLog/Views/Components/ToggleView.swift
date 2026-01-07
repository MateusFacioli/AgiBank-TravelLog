//
//  ToggleView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

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
