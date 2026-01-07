//
//  AppState.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var userName = ""
    @Published var theme = "Claro"
}
