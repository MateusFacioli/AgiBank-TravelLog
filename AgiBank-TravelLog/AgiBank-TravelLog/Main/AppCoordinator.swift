//
//  AppCoordinator.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//


//import UIKit
//import SwiftUI
//
//
//protocol Coordinator: AnyObject {
//    var nav: UINavigationController { get }
//    func start()
//}
//
//final class AppCoordinator: Coordinator {
//    let nav: UINavigationController
//
//    init(nav: UINavigationController = UINavigationController()) {
//        self.nav = nav
//    }
//
//    func start() {
//        let rootView = ContentView()
//        let hosting = UIHostingController(rootView: rootView) //define para onde vai
//        nav.setViewControllers([hosting], animated: true)
//    }
//}


import SwiftUI

// Rotas tipadas para a NavigationStack
enum Route: Hashable {
    case dashboard
    case profile
    case settings
    case travelLog
}

// Coordinator em SwiftUI
final class AppCoordinator: ObservableObject {
    // NavigationPath usado pelo NavigationStack
    @Published var nav = NavigationPath()
    
    // View raiz do app
    var rootView: some View {
        DashboardView()
            .environmentObject(self) // definindo de onde veio
    }
    
    // Navegação programática
    func navigate(to route: Route) {
        nav.append(route)
    }
    
    func pop() {
        if !nav.isEmpty {
            nav.removeLast()
        }
    }
   
    func popToRoot() {
        nav = NavigationPath()
    }
    
    // Resolve a rota para uma View
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .dashboard:
            DashboardView()
        case .profile:
            ProfileView()
        case .settings:
            SettingsView()
        case .travelLog:
            TravelLogView()
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        List {
            Section("Dashboard") {
                Button("Ir para Profile") {
                    coordinator.navigate(to: .profile)
                }
                Button("Ir para Settings") {
                    coordinator.navigate(to: .settings)
                }
                Button("Ir para Travel Log") {
                    coordinator.navigate(to: .travelLog)
                }
            }
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Root") { coordinator.popToRoot() }
            }
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Profile")
                .font(.largeTitle)
            Button("Voltar") { coordinator.pop() }
        }
        .navigationTitle("Profile")
    }
}

struct SettingsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.largeTitle)
            Button("Voltar") { coordinator.pop() }
        }
        .navigationTitle("Settings")
    }
}

struct TravelLogView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Travel Log")
                .font(.largeTitle)
            Button("Voltar") { coordinator.pop() }
        }
        .navigationTitle("Travel Log")
    }
}


/*
 Ambas têm o mesmo propósito (coordenar navegação), mas:
 • UIKit usa UINavigationController imperativo + protocolo para contrato.
 • SwiftUI usa NavigationStack declarativo + enum Route para dados de navegação.
 */
