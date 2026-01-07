//
//  TextFieldView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

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
