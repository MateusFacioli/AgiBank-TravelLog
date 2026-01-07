//
//  AlertView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

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
