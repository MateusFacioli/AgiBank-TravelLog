//
//  ChildView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct ChildView: View {
    @Binding var texto: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("View Filha (ChildView)")
                .font(.headline)
            
            TextField("Digite na filha", text: $texto)
                .textFieldStyle(.roundedBorder)
            
            Text("Valor na filha: \(texto)")
                .font(.caption)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}
