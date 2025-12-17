//
//  TransportDetailView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import SwiftUI
import MapKit

struct TransportDetailView: View {
    let transport: TransportOptionModel
    @State private var route: MKRoute?
    @State private var showingRoute = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerView
                    Divider()
                    routeDetailsView
                    Divider()
                    
                    if !transport.details.isEmpty {
                        instructionsView
                    }
                    
                    if let route = route {
                        routeMapView(route)
                    }
                    
                    actionsView
                }
                .padding()
            }
            .navigationTitle("Detalhes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") { }
                }
            }
            .task {
                await calculateRoute()
            }
        }
    }
    
    private var headerView: some View {
        HStack(spacing: 16) {
            Image(systemName: transport.icon)
                .font(.largeTitle)
                .foregroundStyle(transport.color)
                .frame(width: 60, height: 60)
                .background(transport.color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transport.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Label("\(transport.type.rawValue)", systemImage: transport.icon)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let price = transport.price {
                    Text(price)
                        .font(.headline)
                        .foregroundStyle(.green)
                }
            }
            
            Spacer()
        }
    }
    
    private var routeDetailsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detalhes da Rota")
                .font(.headline)
            
            HStack(spacing: 20) {
                VStack {
                    Image(systemName: "clock")
                        .font(.title2)
                        .foregroundStyle(.blue)
                    Text("\(transport.duration) min")
                        .font(.headline)
                    Text("Duração")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Image(systemName: "arrow.triangle.swap")
                        .font(.title2)
                        .foregroundStyle(.green)
                    Text("\(String(format: "%.1f", transport.distance)) km")
                        .font(.headline)
                    Text("Distância")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Image(systemName: "speedometer")
                        .font(.title2)
                        .foregroundStyle(.orange)
                    Text("\(Int(Double(transport.distance) / Double(transport.duration) * 60)) km/h")
                        .font(.headline)
                    Text("Velocidade média")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var instructionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instruções")
                .font(.headline)
            
            ForEach(Array(transport.details.enumerated()), id: \.offset) { index, detail in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(transport.color)
                        .clipShape(Circle())
                    
                    Text(detail)
                        .font(.body)
                    
                    Spacer()
                }
            }
        }
    }
    
    private func routeMapView(_ route: MKRoute) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mapa da Rota")
                .font(.headline)
            
            Map {
                MapPolyline(route.polyline)
                    .stroke(transport.color, lineWidth: 4)
                
                Annotation("Início", coordinate: route.polyline.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title2)
                }
                
                // Obtém o ponteiro para os pontos
                let points = route.polyline.points()
                // Calcula o índice do último ponto (contagem - 1)
                let lastPointIndex = route.polyline.pointCount - 1
                // Cria um CLLocationCoordinate2D a partir do último ponto
                let lastCoordinate = points[lastPointIndex].coordinate

                Annotation("Fim", coordinate: lastCoordinate) {
                    Image(systemName: "flag.circle.fill")
                        .foregroundStyle(.red)
                        .font(.title2)
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var actionsView: some View {
        VStack(spacing: 12) {
            Button(action: {
                // Abrir app de transporte (Uber, 99, etc.)
                openTransportApp()
            }) {
                Label("Solicitar Transporte", systemImage: "car.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(transport.color)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button(action: {
                // Compartilhar rota
                shareRoute()
            }) {
                Label("Compartilhar Rota", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Helper Methods
    private func calculateRoute() async {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(
            coordinate: CLLocationCoordinate2D(
                latitude: -23.5505,
                longitude: -46.6333
            )
        ))
        request.destination = MKMapItem(placemark: MKPlacemark(
            coordinate: transport.coordinate
        ))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        do {
            let response = try await directions.calculate()
            route = response.routes.first
        } catch {
            print("Erro ao calcular rota: \(error)")
        }
    }
    
    private func openTransportApp() {
        // Abre o app de transporte correspondente
        let uberURL = URL(string: "uber://")!
        let ninetyNineURL = URL(string: "99app://")!
        
        if UIApplication.shared.canOpenURL(uberURL) {
            UIApplication.shared.open(uberURL)
        } else if UIApplication.shared.canOpenURL(ninetyNineURL) {
            UIApplication.shared.open(ninetyNineURL)
        } else {
            // Fallback para App Store
            UIApplication.shared.open(URL(string: "https://apps.apple.com/br/app/uber/id368677368")!)
        }
    }
    
    private func shareRoute() {
        let activityVC = UIActivityViewController(
            activityItems: ["Rota para \(transport.name): \(transport.distance)km em \(transport.duration)min"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    // Crie um modelo de transporte de exemplo
    let sampleTransport = TransportOptionModel(
        name: "Uber X",
        type: .rideSharing,
        icon: "car.fill",
        color: .black,
        coordinate: CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333),
        duration: 8,
        distance: 3.2,
        price: "R$ 15-20",
        details: [
            "Carro chega em 5 minutos",
            "Motorista: João Silva - 4.8★",
            "Tempo estimado: 8 minutos",
            "Trânsito leve no trajeto"
        ]
    )
    
    return TransportDetailView(transport: sampleTransport)
        .previewDisplayName("Transport Detail")
        .previewLayout(.sizeThatFits)
}

#Preview("Taxi Option") {
    let taxiTransport = TransportOptionModel(
        name: "Táxi Convencional",
        type: .taxi,
        icon: "taxi.fill",
        color: .yellow,
        coordinate: CLLocationCoordinate2D(latitude: -23.551, longitude: -46.634),
        duration: 5,
        distance: 1.8,
        price: "R$ 12-18",
        details: [
            "Disponível imediatamente",
            "Tarifa fixa zona centro",
            "Pagamento: Cartão/Dinheiro"
        ]
    )
    
    return TransportDetailView(transport: taxiTransport)
        .previewDisplayName("Taxi Detail")
}

#Preview("Public Transport") {
    let busTransport = TransportOptionModel(
        name: "Ônibus 701P",
        type: .bus,
        icon: "bus.fill",
        color: .green,
        coordinate: CLLocationCoordinate2D(latitude: -23.549, longitude: -46.632),
        duration: 15,
        distance: 2.5,
        price: "R$ 4,40",
        details: [
            "Próximo em 5 minutos",
            "Terminal: Pinheiros",
            "Frequência: 10 minutos",
            "Ar condicionado: Sim"
        ]
    )
    
    return TransportDetailView(transport: busTransport)
        .previewDisplayName("Bus Detail")
}
