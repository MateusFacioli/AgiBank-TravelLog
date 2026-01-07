//
//  HorizontalCardView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

struct HorizontalCardView: View {
    let index: Int
    let color: Color
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.2))
                .frame(width: 120, height: 120)
                .overlay {
                    VStack {
                        Text("Item")
                            .font(.caption)
                        Text("\(index)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
            
            Text("Card \(index)")
                .font(.caption)
                .padding(.top, 5)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
