//
//  ContentView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 10/12/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showSplash = true
    @State private var showMain = false
    var body: some View {
        ZStack {
            if showMain {
                Group {
                    if authVM.isSignedIn {
                        VStack(spacing: 20) {
                            HeaderLogoView()
                                .frame(width: 80, height: 80)

                            Text("Signed in as \(authVM.userEmail ?? "unknown")")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Button(action: {
                                authVM.signOut { _ in }
                            }) {
                                Text("Sign Out")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)

                            Spacer()
                        }
                        .padding()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    } else {
                        // Not signed in -> show LoginView
                        LoginView()
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .zIndex(0)
            }

            if showSplash {
                SplashScreenView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showSplash = false
                        showMain = true
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        // smooth state-driven animations
        .animation(.easeInOut(duration: 0.45), value: showSplash)
        .animation(.easeInOut(duration: 0.45), value: showMain)
    }
}

// Small header logo used when user is signed-in
private struct HeaderLogoView: View {
    var body: some View {
        Group {
            if let uiImage = UIImage(named: "AppLogo") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                // fallback system symbol if no asset named "AppLogo" exists yet
                Image(systemName: "airplane")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
            }
        }
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 6, y: 3)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
