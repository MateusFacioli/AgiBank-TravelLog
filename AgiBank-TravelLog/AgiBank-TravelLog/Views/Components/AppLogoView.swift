//
//  AppLogoView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI

struct AppLogoView: View {
    enum Size {
        case small
        case medium
        case large
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 24
            case .medium: return 40
            case .large: return 60
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 28
            case .large: return 40
            }
        }
        
        var containerSize: CGFloat {
            switch self {
            case .small: return 50
            case .medium: return 100
            case .large: return 150
            }
        }
    }
    
    let size: Size
    let animated: Bool
    
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    init(size: Size = .medium, animated: Bool = false) {
        self.size = size
        self.animated = animated
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.1, green: 0.3, blue: 0.6),
                                Color(red: 0.2, green: 0.4, blue: 0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size.containerSize, height: size.containerSize)
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: "airplane")
                    .font(.system(size: size.iconSize, weight: .bold))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(rotation))
                    .scaleEffect(scale)
            }
            .frame(width: size.containerSize, height: size.containerSize)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Travel Log")
                    .font(.system(size: size.fontSize, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Suas aventuras")
                    .font(.system(size: size.fontSize * 0.6, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            if animated {
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
        ) {
            scale = 2.1//
        }
        
        withAnimation(
            .linear(duration: 4.0)
            .repeatForever(autoreverses: false)
        ) {
            rotation = 6*(360)//
        }
    }
}

#Preview("Airplaines") {
    AppLogoView(size: .small)
        .padding()
    AppLogoView(size: .medium)
        .padding()
    AppLogoView(size: .large, animated: true)
        .padding()
        .background(Color.gray.opacity(0.1))
}
