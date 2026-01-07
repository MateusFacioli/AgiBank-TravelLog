//
//  StateView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

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
