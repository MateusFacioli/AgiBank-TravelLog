//
//  ObservedObjectView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//


import SwiftUI

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
