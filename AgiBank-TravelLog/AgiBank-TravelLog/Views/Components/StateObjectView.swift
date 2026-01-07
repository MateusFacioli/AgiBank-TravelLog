//
//  StateObjectView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

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
