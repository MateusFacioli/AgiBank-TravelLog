//
//  FlyingAirplaneView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI

// Small flying airplane animation used during login
 struct FlyingAirplaneView: View {
    // Called when the simple animation completes
    var onComplete: () -> Void

    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // moving airplane icon
                Image(systemName: "airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(geo.size.width, geo.size.height) * 0.45,
                           height: min(geo.size.width, geo.size.height) * 0.45)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(animate ? -15 : 0))
                    .offset(x: animate ? geo.size.width * 0.6 : -geo.size.width * 0.6,
                            y: animate ? -geo.size.height * 0.15 : geo.size.height * 0.15)
                    .opacity(animate ? 1.0 : 0.95)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
                    .animation(.easeInOut(duration: 0.9), value: animate)
            }
            .onAppear {
                // start movement
                animate = true

                // call completion shortly after animation ends
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                    onComplete()
                }
            }
        }
        .clipped()
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.3, blue: 0.6),
                Color(red: 0.2, green: 0.4, blue: 0.8)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        FlyingAirplaneView {
            print("Animação completa!")
        }
    }
}
