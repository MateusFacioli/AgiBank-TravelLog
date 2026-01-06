//
//  TransportMapView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 16/12/25.
//

import SwiftUI
import MapKit

/**
 Representa um componente UIViewRepresentable que exibe um mapa interativo com opções de transporte integradas ao SwiftUI.
 Atua como bridge entre UIKit (MKMapView) e SwiftUI, mostrando anotações, círculos de raio e interagindo com um ViewModel.
 */
struct TransportMapView: UIViewRepresentable {
    /// ViewModel que provê dados e lógica para o mapa.
    @ObservedObject var viewModel: TransportViewModel
    
    /**
     Cria e configura a instância inicial do MKMapView.
     
     - Parameter context: O contexto do UIViewRepresentable.
     - Returns: Um MKMapView configurado para exibir o mapa com as opções de transporte.
     */
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
    
    /**
     Atualiza o MKMapView com novas anotações, região e overlays com base no ViewModel.
     
     - Parameters:
       - mapView: A instância do MKMapView a ser atualizada.
       - context: O contexto do UIViewRepresentable.
     */
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
    
    /**
     Verifica se a região do mapa foi alterada pelo usuário comparando com a região do ViewModel.
     
     - Parameter mapView: A instância do MKMapView para verificar.
     - Returns: `true` se a região foi alterada pelo usuário; caso contrário, `false`.
     */
    private func regionChangedByUser(_ mapView: MKMapView) -> Bool {
        // Detecta se o usuário interagiu com o mapa
        return mapView.region.center.latitude != viewModel.region.center.latitude ||
               mapView.region.center.longitude != viewModel.region.center.longitude
    }
    
    /**
     Atualiza o overlay de círculo representando o raio de busca no mapa.
     
     Remove overlays antigos e adiciona um novo círculo baseado na localização do usuário e raio definido no ViewModel.
     
     - Parameter mapView: A instância do MKMapView onde o overlay será aplicado.
     */
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
    
    /**
     Cria o coordinator que atua como delegate do MKMapView.
     
     - Returns: Uma instância do Coordinator responsável por gerenciar callbacks do mapa.
     */
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /**
     Coordinator que atua como delegate do MKMapView e gerencia callbacks de interação e renderização.
     
     Responsável por fornecer views para anotações, renderizadores para overlays e responder a eventos do mapa.
     */
    class Coordinator: NSObject, MKMapViewDelegate {
        /// Referência para a parent TransportMapView para acessar propriedades e métodos.
        var parent: TransportMapView
        
        /**
         Inicializa o Coordinator com a parent TransportMapView.
         
         - Parameter parent: A instância da TransportMapView que cria este Coordinator.
         */
        init(_ parent: TransportMapView) {
            self.parent = parent
        }
        
        /**
         Fornece a view customizada para cada anotação no mapa.
         
         - Parameters:
           - mapView: O MKMapView solicitante.
           - annotation: A anotação a ser apresentada.
         - Returns: Uma MKAnnotationView configurada para a anotação ou nil para usar padrão.
         */
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
        
        /**
         Fornece o renderer para overlays adicionados ao mapa.
         
         - Parameters:
           - mapView: O MKMapView solicitante.
           - overlay: O overlay a ser renderizado.
         - Returns: Um MKOverlayRenderer apropriado para o overlay fornecido.
         */
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
        
        /**
         Lida com a ação de toque no botão de callout da anotação.
         
         - Parameters:
           - mapView: O MKMapView onde o evento ocorreu.
           - view: A view da anotação contendo o callout.
           - control: O controle acionado (ex: botão).
         */
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                     calloutAccessoryControlTapped control: UIControl) {
            guard let transportAnnotation = view.annotation as? TransportAnnotation else {
                return
            }
            
            // Aqui você pode implementar ação ao tocar no callout
            print("Transporte selecionado: \(transportAnnotation.transport.name)")
        }
        
        /**
         Notifica quando a região visível do mapa mudou, atualizando o ViewModel para refletir a nova região.
         
         - Parameters:
           - mapView: O MKMapView que sofreu alteração de região.
           - animated: Indica se a transição foi animada.
         */
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Atualiza o viewModel quando o usuário move o mapa
            parent.viewModel.region = mapView.region
        }
    }
}

// MARK: - Custom Annotation

/**
 Representa uma anotação customizada no mapa de transporte, contendo localização e informações resumidas para exibição.

 Utilizada para mostrar opções de transporte específicas com título e subtítulo descritivos.
 */
class TransportAnnotation: NSObject, MKAnnotation {
    /// Modelo de opção de transporte associado à anotação.
    let transport: TransportOptionModel
    
    /// Coordenadas geográficas onde a anotação será posicionada no mapa.
    var coordinate: CLLocationCoordinate2D
    
    /// Título da anotação, geralmente o nome do transporte.
    var title: String?
    
    /// Subtítulo contendo detalhes adicionais como duração e distância.
    var subtitle: String?
    
    /**
     Inicializa uma nova anotação de transporte com base em um modelo de opção.
     
     - Parameter transport: O modelo de transporte que contém dados para a anotação.
     */
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
