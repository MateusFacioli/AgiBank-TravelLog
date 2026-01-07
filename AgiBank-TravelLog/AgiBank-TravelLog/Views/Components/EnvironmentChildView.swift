//
//  EnvironmentChildView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

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
