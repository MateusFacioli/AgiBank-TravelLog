//
//  TransportMapView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import SwiftUI
import MapKit

struct TransportMapView: UIViewRepresentable {
    @ObservedObject var viewModel: TransportViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isRotateEnabled = false
        mapView.showsCompass = true
        mapView.showsScale = true
        
        // Configurações de estilo
        mapView.mapType = .standard
        mapView.pointOfInterestFilter = .excludingAll
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Atualiza região do mapa
        if !regionChangedByUser(mapView) {
            mapView.setRegion(viewModel.region, animated: true)
        }
        
        // Remove anotações antigas
        let oldAnnotations = mapView.annotations.filter {
            $0 is TransportAnnotation 
        }
        mapView.removeAnnotations(oldAnnotations)
        
        // Adiciona novas anotações
        let annotations = viewModel.transportOptions.map { option in
            TransportAnnotation(transport: option)
        }
        mapView.addAnnotations(annotations)
        
        // Adiciona círculo de raio de busca
        updateSearchRadiusOverlay(mapView)
    }
    
    private func regionChangedByUser(_ mapView: MKMapView) -> Bool {
        // Detecta se o usuário interagiu com o mapa
        return mapView.region.center.latitude != viewModel.region.center.latitude ||
               mapView.region.center.longitude != viewModel.region.center.longitude
    }
    
    private func updateSearchRadiusOverlay(_ mapView: MKMapView) {
        // Remove overlays antigos
        let oldOverlays = mapView.overlays.filter {
            $0 is MKCircle
        }
        mapView.removeOverlays(oldOverlays)
        
        // Adiciona novo círculo de raio
        if let userLocation = viewModel.userLocation {
            let circle = MKCircle(
                center: userLocation.coordinate,
                radius: viewModel.searchRadius * 1000 // metros
            )
            mapView.addOverlay(circle)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: TransportMapView
        
        init(_ parent: TransportMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let transportAnnotation = annotation as? TransportAnnotation else {
                return nil
            }
            
            let identifier = "TransportAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: identifier
                )
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            
            if let markerView = annotationView as? MKMarkerAnnotationView {
                markerView.markerTintColor = UIColor(transportAnnotation.transport.color)
                markerView.glyphImage = UIImage(systemName: transportAnnotation.transport.icon)
                markerView.glyphTintColor = .white
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circleOverlay = overlay as? MKCircle {
                let renderer = MKCircleRenderer(circle: circleOverlay)
                renderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
                renderer.strokeColor = UIColor.blue.withAlphaComponent(0.3)
                renderer.lineWidth = 1
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, 
                    calloutAccessoryControlTapped control: UIControl) {
            guard let transportAnnotation = view.annotation as? TransportAnnotation else {
                return
            }
            
            // Aqui você pode implementar ação ao tocar no callout
            print("Transporte selecionado: \(transportAnnotation.transport.name)")
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Atualiza o viewModel quando o usuário move o mapa
            parent.viewModel.region = mapView.region
        }
    }
}

// MARK: - Custom Annotation
class TransportAnnotation: NSObject, MKAnnotation {
    let transport: TransportOptionModel
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(transport: TransportOptionModel) {
        self.transport = transport
        self.coordinate = transport.coordinate
        self.title = transport.name
        self.subtitle = "\(transport.duration) min • \(transport.distance)km"
        super.init()
    }
}

// MARK: - Previews usando MockData

#Preview("Mapa com Transportes") {
    let mockViewModel = MockData.createTransportViewModel()
    
    return TransportMapView(viewModel: mockViewModel)
        .frame(height: 400)
        .previewDisplayName("Mapa com Transportes")
        .previewLayout(.sizeThatFits)
}

#Preview("Mapa com Localização do Usuário") {
    let mockViewModel = MockData.createTransportViewModel()
    
    return TransportMapView(viewModel: mockViewModel)
        .frame(height: 400)
        .previewDisplayName("Mapa com Localização do Usuário")
        .previewLayout(.sizeThatFits)
}

#Preview("Mapa Vazio") {
    let mockViewModel = MockData.createTransportViewModel()
    mockViewModel.transportOptions = [] // Mapa vazio
    
    return TransportMapView(viewModel: mockViewModel)
        .frame(height: 400)
        .previewDisplayName("Mapa Vazio")
        .previewLayout(.sizeThatFits)
}

#Preview("Apenas Carros") {
    let mockViewModel = MockData.createTransportViewModel()
    // Filtra apenas carros para o preview
    mockViewModel.transportOptions = mockViewModel.transportOptions.filter { option in
        option.type == .rideSharing || option.type == .taxi
    }
    
    return TransportMapView(viewModel: mockViewModel)
        .frame(height: 400)
        .previewDisplayName("Apenas Carros")
        .previewLayout(.sizeThatFits)
}

#Preview("Transportes Sustentáveis") {
    let mockViewModel = MockData.createTransportViewModel()
    // Filtra transportes sustentáveis
    mockViewModel.transportOptions = mockViewModel.transportOptions.filter { option in
        option.type == .bike || option.type == .scooter || option.type == .subway || option.type == .bus
    }
    
    return TransportMapView(viewModel: mockViewModel)
        .frame(height: 400)
        .previewDisplayName("Transportes Sustentáveis")
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
}

// Preview para diferentes dispositivos
#Preview("iPhone 15 Pro") {
    let mockViewModel = MockData.createTransportViewModel()
    
    return TransportMapView(viewModel: mockViewModel)
        .frame(height: 600)
        .previewDevice("iPhone 15 Pro")
        .previewDisplayName("iPhone 15 Pro")
}

#Preview("iPad") {
    let mockViewModel = MockData.createTransportViewModel()
    
    return TransportMapView(viewModel: mockViewModel)
        .frame(height: 800)
        .previewDevice("iPad Pro (11-inch)")
        .previewDisplayName("iPad")
}

// Preview interativo para desenvolvimento
struct TransportMapViewPreview: View {
    @StateObject private var viewModel = MockData.createTransportViewModel()
    
    var body: some View {
        VStack {
            Text("Mapa de Transportes - Preview Interativo")
                .font(.headline)
                .padding()
            
            TransportMapView(viewModel: viewModel)
                .frame(height: 500)
                .cornerRadius(12)
                .shadow(radius: 5)
            
            // Controles para o preview
            VStack {
                HStack {
                    Text("Opções: \(viewModel.transportOptions.count)")
                    Spacer()
                    Button("Resetar") {
                        viewModel.transportOptions = MockData.transportOptions
                    }
                }
                .padding(.horizontal)
                
                Slider(value: .constant(5.0), in: 0.5...20.0)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview("Preview Interativo") {
    TransportMapViewPreview()
}
