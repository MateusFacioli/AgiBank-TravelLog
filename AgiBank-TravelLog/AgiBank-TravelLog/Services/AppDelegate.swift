//
//  AppDelegate.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 31/12/25.
//

import SwiftUI
import FirebaseCore

/// AppDelegate usado para inicializar bibliotecas no lançamento do app.
///
/// Atualmente chama `FirebaseApp.configure()` no `didFinishLaunchingWithOptions`.
class AppDelegate: NSObject, UIApplicationDelegate {
  /// Método chamado ao terminar o processo de lançamento da aplicação.
  /// - Returns: `true` quando a inicialização foi concluída com sucesso.
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
