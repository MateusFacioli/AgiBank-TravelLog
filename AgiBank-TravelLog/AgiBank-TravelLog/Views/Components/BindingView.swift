//
//  BindingView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

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
