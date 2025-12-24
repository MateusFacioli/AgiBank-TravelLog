////
////  AppIconGenerator.swift
////  AgiBank-TravelLog
////
////  Created by Mateus Rodrigues on 19/12/25.
////
//
//
////
////  AppIconGenerator.swift
////  AgiBank-TravelLog
////
//
//import UIKit
//import SwiftUICore
//
//struct AppIconGenerator {
//    
//    static func generateAppIcon() {
//        // Tamanhos necessários para iOS
//        let sizes: [CGFloat] = [
//            20, 29, 40, 60, 76, 83.5, // Single scale
//            40, 58, 80, 120, 152, 167, // @2x scale
//            60, 87, 120, 180, // @3x scale
//            1024 // App Store
//        ]
//        
//        for size in sizes {
//            let image = generateIcon(size: size)
//            saveImage(image, size: size)
//        }
//    }
//    
//    private static func generateIcon(size: CGFloat) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
//        
//        return renderer.image { context in
//            // Cor de fundo (azul do seu gradiente)
//            let rectangle = CGRect(x: 0, y: 0, width: size, height: size)
//            
//            // Gradiente de fundo
//            let colors = [
//                UIColor(red: 0.1, green: 0.3, blue: 0.6, alpha: 1.0).cgColor,
//                UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0).cgColor
//            ]
//            
//            let gradient = CGGradient(
//                colorsSpace: CGColorSpaceCreateDeviceRGB(),
//                colors: colors as CFArray,
//                locations: [0.0, 1.0]
//            )!
//            
//            context.cgContext.drawLinearGradient(
//                gradient,
//                start: CGPoint(x: 0, y: 0),
//                end: CGPoint(x: size, y: size),
//                options: []
//            )
//            
//            // Criar o símbolo do avião
//            let config = UIImage.SymbolConfiguration(pointSize: size * 0.5, weight: .bold)
//            if let airplaneImage = UIImage(systemName: "airplane.circle.fill", withConfiguration: config)?
//                .withTintColor(.white, renderingMode: .alwaysOriginal) {
//                
//                let imageSize = CGSize(width: size * 0.6, height: size * 0.6)
//                let imageRect = CGRect(
//                    x: (size - imageSize.width) / 2,
//                    y: (size - imageSize.height) / 2,
//                    width: imageSize.width,
//                    height: imageSize.height
//                )
//                
//                airplaneImage.draw(in: imageRect)
//            }
//        }
//    }
//    
//    private static func saveImage(_ image: UIImage, size: CGFloat) {
//        // Para testes, salva no desktop
//        if let data = image.pngData(),
//           let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let filename = documents.appendingPathComponent("AppIcon_\(Int(size))x\(Int(size))@1x.png")
//            try? data.write(to: filename)
//            print("✅ Icone salvo: \(filename.lastPathComponent)")
//        }
//    }
//}
//
//// View para preview do ícone
//struct AppIconPreviewView: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            // Ícone 1024x1024 (App Store)
//            Image(uiImage: generatePreviewIcon(size: 200))
//                .resizable()
//                .frame(width: 200, height: 200)
//                .clipShape(RoundedRectangle(cornerRadius: 40))
//                .shadow(radius: 10)
//            
//            Text("AgiBank Travel Log")
//                .font(.title.bold())
//            
//            Text("airplane.circle.fill")
//                .font(.headline)
//                .foregroundColor(.blue)
//            
//            Button("Gerar Ícones") {
//                AppIconGenerator.generateAppIcon()
//            }
//            .buttonStyle(.borderedProminent)
//            .padding()
//            
//            Spacer()
//        }
//        .padding()
//    }
//    
//    private func generatePreviewIcon(size: CGFloat) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
//        
//        return renderer.image { context in
//            // Fundo
//            let colors = [
//                UIColor(red: 0.1, green: 0.3, blue: 0.6, alpha: 1.0).cgColor,
//                UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0).cgColor
//            ]
//            
//            let gradient = CGGradient(
//                colorsSpace: CGColorSpaceCreateDeviceRGB(),
//                colors: colors as CFArray,
//                locations: [0.0, 1.0]
//            )!
//            
//            context.cgContext.drawLinearGradient(
//                gradient,
//                start: CGPoint(x: 0, y: 0),
//                end: CGPoint(x: size, y: size),
//                options: []
//            )
//            
//            // Avião
//            let config = UIImage.SymbolConfiguration(pointSize: size * 0.5, weight: .bold)
//            if let airplaneImage = UIImage(systemName: "airplane.circle.fill", withConfiguration: config)?
//                .withTintColor(.white, renderingMode: .alwaysOriginal) {
//                
//                let imageSize = CGSize(width: size * 0.6, height: size * 0.6)
//                let imageRect = CGRect(
//                    x: (size - imageSize.width) / 2,
//                    y: (size - imageSize.height) / 2,
//                    width: imageSize.width,
//                    height: imageSize.height
//                )
//                
//                airplaneImage.draw(in: imageRect)
//            }
//        }
//    }
//}
//
//#Preview {
//    AppIconPreviewView()
//}
