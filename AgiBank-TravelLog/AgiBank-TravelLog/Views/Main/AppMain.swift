//
//  AppMain.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 31/12/25.
//

import Foundation
import SwiftUI
import FirebaseCore

@MainActor
struct AgiBankTravelLogApp: App {
    @StateObject private var authVM = AuthViewModel()

    init() {
        // Configure Firebase once at app startup
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
        }
    }
}
