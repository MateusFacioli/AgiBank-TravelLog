//
//  ScrollCardView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct ScrollCardView: View {
    let index: Int
    let color: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay {
                    Text("\(index)")
                        .fontWeight(.bold)
                }
            
            VStack(alignment: .leading) {
                Text("Item \(index)")
                    .font(.headline)
                Text("Descrição do item \(index)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .id(index)
    }
}
