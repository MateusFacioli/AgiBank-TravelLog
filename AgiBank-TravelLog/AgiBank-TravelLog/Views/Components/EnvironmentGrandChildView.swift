//
//  EnvironmentGrandChildView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

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
