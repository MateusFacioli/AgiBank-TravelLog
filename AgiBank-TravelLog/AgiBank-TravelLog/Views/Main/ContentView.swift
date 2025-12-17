//
//  ContentView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 10/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var showLogin = false
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSplash = false
                        showLogin = true
                    }
                }
                .transition(.opacity)
            }
            
            if showLogin {
                LoginView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: showLogin)
    }
}

#Preview {
    ContentView()
}
