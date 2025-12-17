//
//  EmptyStateMenuView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import SwiftUI

struct EmptyStateMenuView: View {
    let category: MenuItem.MenuCategory
    var onAddAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: category.icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.3))

            VStack(spacing: 8) {
                Text(category.emptyStateTitle)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(category.emptyStateMessage)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button(action: {
                onAddAction?()
            }) {
                Label("Adicionar Viagem", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .background {
                        Capsule()
                            .fill(Color.accentColor)
                            .shadow(
                                color: .accentColor.opacity(0.3),
                                radius: 8,
                                y: 4
                            )
                    }
                    .foregroundColor(.white)
                    .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, 8)
        }
    }
}
