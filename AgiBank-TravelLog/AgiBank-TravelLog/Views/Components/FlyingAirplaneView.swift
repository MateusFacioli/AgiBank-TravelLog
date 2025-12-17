//
//  FlyingAirplaneView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI

struct FlyingAirplaneView: View {
    @State private var airplaneOffset = CGSize.zero
    @State private var airplaneRotation: Double = 0
    @State private var airplaneScale: CGFloat = 1.0
    @State private var airplaneOpacity: CGFloat = 1.0
    @State private var trailOpacity: Double = 0.0
    @State private var circlePulseScale: CGFloat = 1.0
    @State private var circleOpacity: CGFloat = 1.0
    @State private var isAnimating = false
    
    let onAnimationComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Círculo de fundo pulsante
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.3),
                            .white.opacity(0.1),
                            .clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(width: 80, height: 80)
                .scaleEffect(circlePulseScale)
                .opacity(circleOpacity)
                .animation(
                    .easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true),
                    value: circlePulseScale
                )
            
            // Avião
            Image(systemName: "airplane")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .offset(x: airplaneOffset.width, y: airplaneOffset.height)
                .rotationEffect(.degrees(airplaneRotation))
                .scaleEffect(airplaneScale)
                .opacity(airplaneOpacity)
            
            // Trilha do avião (efeito de movimento)
            if trailOpacity > 0 {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    .white.opacity(0.6),
                                    .blue.opacity(0.3),
                                    .clear
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: CGFloat(10 - index * 3)
                            )
                        )
                        .frame(width: CGFloat(20 - index * 5), height: CGFloat(20 - index * 5))
                        .offset(x: airplaneOffset.width - CGFloat(15 + index * 8),
                               y: airplaneOffset.height)
                        .opacity(trailOpacity * (1.0 - CGFloat(index) * 0.3))
                        .blur(radius: CGFloat(index) * 1.0)
                }
            }
        }
        .onAppear {
            startAnimationSequence()
        }
    }
    
    private func startAnimationSequence() {
        guard !isAnimating else { return }
        isAnimating = true
        
        // Inicia animação do círculo pulsante
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            circlePulseScale = 1.2
        }
        
        // Sequência de animação conforme especificada:
        
        // 0-2 segundos: Logo aparece normalmente (já está visível)
        
        // 2 segundos: Avião começa a vibrar levemente
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { // Começa imediatamente para demo
            self.vibrationPhase()
        }
    }
    
    private func vibrationPhase() {
        // Fase 1: Vibração (2 segundos)
        withAnimation(.easeInOut(duration: 0.1).repeatCount(4, autoreverses: true)) {
            airplaneOffset = CGSize(width: 2, height: -2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            // Fase 2: Avião sobe 30 pixels (2.3 segundos)
            withAnimation(.easeOut(duration: 0.3)) {
                airplaneOffset = CGSize(width: 0, height: -30)
                trailOpacity = 0.8
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Fase 3: Avião acelera para a direita enquanto sobe (2.8 segundos)
                withAnimation(.easeIn(duration: 0.8)) {
                    airplaneOffset = CGSize(width: 200, height: -100)
                    airplaneRotation = 15
                    airplaneScale = 0.7
                    trailOpacity = 0.6
                }
                
                // Fase 4: Avião desaparece no canto superior direito (3.6 segundos)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeIn(duration: 0.5)) {
                        airplaneOpacity = 0.0
                        trailOpacity = 0.0
                        circleOpacity = 0.0
                    }
                    
                    // 4 segundos: Transição para a próxima tela
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        onAnimationComplete()
                    }
                }
            }
        }
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
