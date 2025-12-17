//
//  RatingView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 15/12/25.
//

import SwiftUI

// MARK: - Rating View Component
struct RatingView: View {
    @Binding var rating: Float
    let size: CGFloat
    let maxRating: Int = 5
    var interactive: Bool = true
    var showValue: Bool = true
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: starType(for: index))
                    .font(.system(size: size))
                    .foregroundStyle(starColor(for: index))
                    .symbolEffect(.bounce, value: rating)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if interactive {
                            withAnimation(
                                .spring(response: 0.3, dampingFraction: 0.7)
                            ) {
                                rating = Float(index)
                            }
                        }
                    }
            }
            
            if showValue {
                Text(String(format: "%.1f", rating))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
    }

    private func starType(for index: Int) -> String {
        let indexFloat = Float(index)
        if rating >= indexFloat {
            return "star.fill"
        } else if rating >= indexFloat - 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }

    private func starColor(for index: Int) -> Color {
        let indexFloat = Float(index)
        if rating >= indexFloat {
            // Estrela cheia - amarelo vibrante
            return Color.yellow
        } else if rating >= indexFloat - 0.5 {
            // Meia estrela - amarelo mais suave
            return Color.yellow.opacity(0.7)
        } else {
            // Estrela vazia - cinza
            return Color.gray.opacity(0.3)
        }
    }
}

// MARK: - Rating View com gradiente (alternativa)
struct GradientRatingView: View {
    @Binding var rating: Float
    let size: CGFloat
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: starType(for: index))
                    .font(.system(size: size))
                    .symbolEffect(.bounce, value: rating)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(
                            .spring(response: 0.3, dampingFraction: 0.7)
                        ) {
                            rating = Float(index)
                        }
                    }
                    .background(
                        LinearGradient(
                            colors: gradientColors(for: index),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .mask(
                            Image(systemName: starType(for: index))
                                .font(.system(size: size))
                        )
                    )
            }
            
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }
    
    private func starType(for index: Int) -> String {
        let indexFloat = Float(index)
        if rating >= indexFloat {
            return "star.fill"
        } else if rating >= indexFloat - 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
    
    private func gradientColors(for index: Int) -> [Color] {
        let indexFloat = Float(index)
        if rating >= indexFloat {
            return [
                Color(red: 1.0, green: 0.9, blue: 0.2),
                Color(red: 1.0, green: 0.8, blue: 0.0)
            ]
        } else if rating >= indexFloat - 0.5 {
            return [
                Color(red: 1.0, green: 0.85, blue: 0.3),
                Color(red: 1.0, green: 0.75, blue: 0.1)
            ]
        } else {
            return [
                Color.gray.opacity(0.3),
                Color.gray.opacity(0.1)
            ]
        }
    }
}

// MARK: - Static Rating View (apenas para exibição)
struct StaticRatingView: View {
    let rating: Float
    let size: CGFloat
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: starType(for: index))
                    .font(.system(size: size))
                    .foregroundColor(starColor(for: index))
            }

            Text(String(format: "%.1f", rating))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }

    private func starType(for index: Int) -> String {
        let indexFloat = Float(index)
        
        if rating >= indexFloat {
            return "star.fill"
        } else if rating >= indexFloat - 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }

    private func starColor(for index: Int) -> Color {
        let indexFloat = Float(index)
        if rating >= indexFloat {
            return Color.yellow
        } else if rating >= indexFloat - 0.5 {
            return Color.yellow.opacity(0.7)
        } else {
            return Color.gray.opacity(0.3)
        }
    }
}

// MARK: - Alternative: Animated Star Rating
struct AnimatedStarRating: View {
    @Binding var rating: Float
    let size: CGFloat
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                StarShape()
                    .fill(starColor(for: index))
                    .frame(width: size, height: size)
                    .overlay(
                        StarShape()
                            .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                    )
                    .scaleEffect(isStarHighlighted(index) ? 1.2 : 1.0)
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.7),
                        value: rating
                    )
                    .onTapGesture {
                        withAnimation {
                            rating = Float(index)
                        }
                    }
            }
        }
    }

    private func isStarHighlighted(_ index: Int) -> Bool {
        return rating >= Float(index)
    }

    private func starColor(for index: Int) -> Color {
        return isStarHighlighted(index) ? .yellow : .gray.opacity(0.2)
    }
}

// MARK: - Custom Star Shape
struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let points = 5
        
        var path = Path()
        
        for i in 0..<points * 2 {
            let angle = CGFloat(i) * .pi / CGFloat(points)
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let point = CGPoint(
                x: center.x + radius * sin(angle),
                y: center.y + radius * cos(angle)
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        VStack {
            Text("RatingView Padrão")
                .font(.headline)
            RatingView(rating: .constant(3.5), size: 24)
        }
        
        Divider()
        
        VStack {
            Text("RatingView com Gradiente")
                .font(.headline)
            GradientRatingView(rating: .constant(4.2), size: 24)
        }
        
        Divider()
        
        VStack {
            Text("StaticRatingView")
                .font(.headline)
            StaticRatingView(rating: 2.8, size: 20)
        }
        
        Divider()
        
        VStack {
            Text("AnimatedStarRating")
                .font(.headline)
            AnimatedStarRating(rating: .constant(4), size: 30)
        }
    }
    .padding()
}
