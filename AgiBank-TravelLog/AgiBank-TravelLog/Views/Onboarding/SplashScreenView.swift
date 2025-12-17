////
////  SplashScreenView.swift
////  AgiBank-TravelLog
////
////  Created by Mateus Rodrigues on 17/12/25.
////
//
//import SwiftUI
//
//struct SplashScreenView: View {
//    @State private var scale = 0.5
//    @State private var opacity = 0.0
//    @State private var textOpacity = 0.0
//    @State private var rotation = 0.0
//    @State private var isAnimating = false
//    @State private var showContent = false
//    
//    var onAnimationComplete: () -> Void
//    
//    var body: some View {
//        ZStack {
//            // Fundo gradiente
//            LinearGradient(
//                colors: [
//                    Color(red: 0.1, green: 0.3, blue: 0.6),
//                    Color(red: 0.2, green: 0.4, blue: 0.8),
//                    Color(red: 0.3, green: 0.5, blue: 0.9)
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//            
//            // Logo principal
//            VStack(spacing: 20) {
//                // Ícone do app animado
//                ZStack {
//                    // Círculo de fundo pulsante
//                    Circle()
//                        .fill(
//                            RadialGradient(
//                                gradient: Gradient(colors: [
//                                    .white.opacity(0.3),
//                                    .white.opacity(0.1),
//                                    .clear
//                                ]),
//                                center: .center,
//                                startRadius: 0,
//                                endRadius: 100
//                            )
//                        )
//                        .scaleEffect(isAnimating ? 1.5 : 0.8)
//                        .opacity(isAnimating ? 0 : 0.5)
//                        .animation(
//                            .easeInOut(duration: 2.0)
//                            .repeatForever(autoreverses: false),
//                            value: isAnimating
//                        )
//                    
//                    // Logo composto
//                    ZStack {
//                        // Círculo externo
//                        Circle()
//                            .stroke(
//                                LinearGradient(
//                                    colors: [.white, .blue.opacity(0.7)],
//                                    startPoint: .topLeading,
//                                    endPoint: .bottomTrailing
//                                ),
//                                lineWidth: 4
//                            )
//                            .frame(width: 120, height: 120)
//                            .rotationEffect(.degrees(rotation))
//                            .scaleEffect(scale)
//                        
//                        // Ícone interno
//                        ZStack {
//                            // Avião principal
//                            Image(systemName: "airplane")
//                                .font(.system(size: 40))
//                                .foregroundColor(.white)
//                            
//                            // Elementos decorativos ao redor
//                            Circle()
//                                .fill(Color.blue)
//                                .frame(width: 20, height: 20)
//                                .offset(x: 50)
//                                .rotationEffect(.degrees(rotation))
//                            
//                            Circle()
//                                .fill(Color.green)
//                                .frame(width: 15, height: 15)
//                                .offset(x: -40, y: -40)
//                                .rotationEffect(.degrees(-rotation))
//                            
//                            Circle()
//                                .fill(Color.orange)
//                                .frame(width: 12, height: 12)
//                                .offset(x: -30, y: 45)
//                                .rotationEffect(.degrees(rotation * 1.5))
//                        }
//                        .scaleEffect(scale)
//                    }
//                }
//                .frame(width: 200, height: 200)
//                
//                // Nome do app
//                VStack(spacing: 8) {
//                    Text("Travel Log")
//                        .font(.system(size: 40, weight: .bold, design: .rounded))
//                        .foregroundColor(.white)
//                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
//                        .opacity(textOpacity)
//                    
//                    Text("by Mateus F.")
//                        .font(.system(size: 24, weight: .medium, design: .rounded))
//                        .foregroundColor(.white.opacity(0.9))
//                        .opacity(textOpacity)
//                    
//                    // Tagline
//                    Text("Registre suas aventuras")
//                        .font(.system(size: 16, weight: .light))
//                        .foregroundColor(.white.opacity(0.8))
//                        .padding(.top, 4)
//                        .opacity(textOpacity)
//                }
//                .padding(.top, 20)
//                
//                // Indicador de carregamento
//                if !showContent {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                        .scaleEffect(1.2)
//                        .padding(.top, 30)
//                        .opacity(textOpacity)
//                }
//            }
//            .scaleEffect(scale)
//            .opacity(opacity)
//        }
//        .onAppear {
//            startAnimation()
//        }
//        .onChange(of: showContent) { newValue in
//            if newValue {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    onAnimationComplete()
//                }
//            }
//        }
//    }
//    
//    private func startAnimation() {
//        // Animação de entrada
//        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
//            scale = 1.0
//            opacity = 1.0
//        }
//        
//        // Animação do círculo giratório
//        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
//            rotation = 360
//        }
//        
//        // Animação do nome do app
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            withAnimation(.easeInOut(duration: 0.8)) {
//                textOpacity = 1.0
//            }
//        }
//        
//        // Inicia animação pulsante
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            isAnimating = true
//        }
//        
//        // Finaliza a splash screen após 3 segundos
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            withAnimation(.easeInOut(duration: 0.5)) {
//                showContent = true
//            }
//        }
//    }
//}
//
//#Preview {
//    SplashScreenView {
//        print("Animação completa!")
//    }
//}


import SwiftUI

struct SplashScreenView: View {
    @State private var scale = 0.5
    @State private var opacity = 0.0
    @State private var textOpacity = 0.0
    @State private var rotation = 0.0
    @State private var isAnimating = false
    @State private var showContent = false
    @State private var airplaneOffset = CGSize.zero
    @State private var airplaneScale: CGFloat = 1.0
    @State private var airplaneOpacity: CGFloat = 1.0
    @State private var trailOpacity = 0.0
    @State private var trailOffset = CGSize.zero
    @State private var showFlyingAnimation = false
    
    var onAnimationComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Fundo gradiente animado
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.3, blue: 0.6),
                    Color(red: 0.2, green: 0.4, blue: 0.8),
                    Color(red: 0.3, green: 0.5, blue: 0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(opacity)
            
            // Logo principal
            VStack(spacing: 20) {
                // Container do logo
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
                                endRadius: 100
                            )
                        )
                        .scaleEffect(isAnimating ? 1.5 : 0.8)
                        .opacity(isAnimating ? 0 : 0.5)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                    
                    // Logo composto
                    ZStack {
                        // Círculo externo
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.white, .blue.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(rotation))
                            .scaleEffect(scale)
                            .opacity(airplaneOpacity)
                        
                        // Avião animado
                        Image(systemName: "airplane")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .offset(x: airplaneOffset.width, y: airplaneOffset.height)
                            .scaleEffect(airplaneScale)
                            .rotationEffect(.degrees(airplaneOffset.width * 0.5))
                            .opacity(airplaneOpacity)
                        
                        // Trilha do avião (efeito de movimento)
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            .white.opacity(0.6),
                                            .blue.opacity(0.4),
                                            .clear
                                        ]),
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: CGFloat(15 - index * 5)
                                    )
                                )
                                .frame(width: CGFloat(30 - index * 10), height: CGFloat(30 - index * 10))
                                .offset(x: airplaneOffset.width - CGFloat(20 + index * 10),
                                       y: airplaneOffset.height)
                                .opacity(trailOpacity * (1.0 - CGFloat(index) * 0.3))
                                .blur(radius: CGFloat(index) * 1.5)
                        }
                        
                        // Elementos decorativos ao redor (ficam parados)
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                            .offset(x: 50)
                            .rotationEffect(.degrees(rotation))
                            .opacity(airplaneOpacity)
                        
                        Circle()
                            .fill(Color.green)
                            .frame(width: 15, height: 15)
                            .offset(x: -40, y: -40)
                            .rotationEffect(.degrees(-rotation))
                            .opacity(airplaneOpacity)
                        
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 12, height: 12)
                            .offset(x: -30, y: 45)
                            .rotationEffect(.degrees(rotation * 1.5))
                            .opacity(airplaneOpacity)
                    }
                    .scaleEffect(scale)
                }
                .frame(width: 200, height: 200)
                
                // Nome do app
                VStack(spacing: 8) {
                    Text("Travel Log")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                        .opacity(textOpacity)
                    
                    Text("Registre suas aventuras")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(textOpacity)
                    
                    // Tagline
                    Text("by M.R.F")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top, 4)
                        .opacity(textOpacity)
                }
                .padding(.top, 20)
                
                // Indicador de carregamento
                if !showContent {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                        .padding(.top, 30)
                        .opacity(textOpacity)
                }
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            startAnimation()
        }
        .onChange(of: showContent) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onAnimationComplete()
                }
            }
        }
    }
    
    private func startAnimation() {
        // Animação de entrada
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Animação do círculo giratório
        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        // Animação do nome do app
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                textOpacity = 1.0
            }
        }
        
        // Inicia animação pulsante
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimating = true
        }
        
        // Animação do avião voando (começa após 2 segundos)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            startAirplaneFlight()
        }
        
        // Finaliza a splash screen após 4 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showContent = true
            }
        }
    }
    
    private func startAirplaneFlight() {
        showFlyingAnimation = true
        
        // Fase 1: Avião se prepara para voar (pequena vibração)
        withAnimation(.easeInOut(duration: 0.3).repeatCount(2, autoreverses: true)) {
            airplaneOffset = CGSize(width: 5, height: -5)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            // Fase 2: Avião começa a voar para cima
            withAnimation(.easeOut(duration: 0.5)) {
                airplaneOffset = CGSize(width: 0, height: -30)
                trailOpacity = 0.8
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Fase 3: Avião acelera para a direita
                withAnimation(.easeIn(duration: 0.8)) {
                    airplaneOffset = CGSize(width: 300, height: -150)
                    airplaneScale = 0.8
                    trailOpacity = 0.6
                }
                
                // Fase 4: Fade out dos elementos do logo
                withAnimation(.easeIn(duration: 0.8)) {
                    airplaneOpacity = 0.0
                    trailOpacity = 0.0
                }
            }
        }
    }
}

#Preview {
    SplashScreenView {
        print("Animação completa!")
    }
}
