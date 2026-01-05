//
//  LoginView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel

    // Form
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false

    // UI / state
    @State private var isLoggingIn: Bool = false
    @State private var showAirplaneAnimation: Bool = false
    @State private var logoOpacity: Double = 1.0
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""

    // Sheets
    @State private var showingRegister: Bool = false
    @State private var showingForgot: Bool = false

    // Focus
    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.06, green: 0.25, blue: 0.48),
                        Color(red: 0.14, green: 0.36, blue: 0.72)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        // Header with animated logo / airplane
                        VStack(spacing: 14) {
                            ZStack {
                                if !showAirplaneAnimation {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    .white.opacity(0.18),
                                                    .white.opacity(0.08)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 96, height: 96)

                                    Image(systemName: "airplane")
                                        .font(.system(size: 36))
                                        .foregroundColor(.white)
                                } else {
                                    FlyingAirplaneView {
                                        // when the airplane animation completes, actually attempt sign in
                                        performSignIn()
                                    }
                                    .frame(width: 96, height: 96)
                                }
                            }
                            .padding(.top, 40)
                            .opacity(logoOpacity)
                            .animation(.easeInOut(duration: 0.25), value: logoOpacity)

                            VStack(spacing: 2) {
                                Text("Travel Log")
                                    .font(.system(size: 30, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)

                                Text("Sua jornada começa aqui")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        .padding(.bottom, 28)
                        .padding(.horizontal, 20)

                        // Form card
                        VStack(spacing: 16) {
                            // Email
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Email")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.95))

                                TextField("seu@email.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .focused($focusedField, equals: .email)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                            }

                            // Password
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Senha")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white.opacity(0.95))

                                ZStack(alignment: .trailing) {
                                    if showPassword {
                                        TextField("Digite sua senha", text: $password)
                                            .textFieldStyle(CustomTextFieldStyle())
                                            .autocapitalization(.none)
                                            .disableAutocorrection(true)
                                    } else {
                                        SecureField("Digite sua senha", text: $password)
                                            .textFieldStyle(CustomTextFieldStyle())
                                    }

                                    Button(action: {
                                        showPassword.toggle()
                                    }) {
                                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 10)
                                    }
                                }
                                .focused($focusedField, equals: .password)
                                .submitLabel(.go)
                                .onSubmit {
                                    validateAndStartLogin()
                                }
                            }

                            // Forgot password
                            HStack {
                                Spacer()
                                Button(action: {
                                    showingForgot = true
                                }) {
                                    Text("Esqueci minha senha")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }

                            // Sign in button
                            Button(action: {
                                validateAndStartLogin()
                            }) {
                                HStack {
                                    if isLoggingIn {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Entrar")
                                            .font(.system(size: 18, weight: .semibold))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color(red: 0.13, green: 0.36, blue: 0.72)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
                            }
                            .disabled(isLoggingIn || showAirplaneAnimation)
                            .padding(.top, 4)

                            // Register link
                            HStack(spacing: 6) {
                                Text("Não tem uma conta?")
                                    .foregroundColor(.white.opacity(0.9))
                                Button(action: {
                                    showingRegister = true
                                }) {
                                    Text("Cadastre-se")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top, 6)
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.07))
                                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
                        )
                        .padding(.horizontal, 20)

                        Spacer(minLength: 24)

                        // Footer
                        VStack(spacing: 4) {
                            Text("© 2025 M.R.F Travel Log")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.75))

                            Text("Versão 1.0.0")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.45))
                        }
                        .padding(.vertical, 18)
                    }
                    .frame(maxWidth: .infinity)
                }
                .contentMargins(.top, 18)
                .onTapGesture {
                    hideKeyboard()
                }

                // Error alert
                .alert("Erro no Login", isPresented: $showErrorAlert, actions: {
                    Button("OK", role: .cancel) { }
                }, message: {
                    Text(errorMessage)
                })
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingRegister) {
                RegisterView()
                    .environmentObject(authVM)
            }
            .sheet(isPresented: $showingForgot) {
                ForgotPasswordView()
                    .environmentObject(authVM)
            }
        }
    }

    // MARK: - Validation + login flow

    private func validateAndStartLogin() {
        // Basic validation (email required and provide simple format check)
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Por favor, digite seu email"
            showErrorAlert = true
            return
        }
        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Por favor, digite um email válido"
            showErrorAlert = true
            return
        }
        if password.isEmpty {
            errorMessage = "Por favor, digite sua senha"
            showErrorAlert = true
            return
        }
        if password.count < 6 {
            errorMessage = "A senha deve ter pelo menos 6 caracteres"
            showErrorAlert = true
            return
        }

        startLoginProcess()
    }

    private func startLoginProcess() {
        hideKeyboard()
        isLoggingIn = true

        // animate logo -> airplane
        withAnimation(.easeInOut(duration: 0.25)) {
            logoOpacity = 0.3
        }
        withAnimation(.easeInOut(duration: 0.25).delay(0.05)) {
            showAirplaneAnimation = true
        }
    }

    private func performSignIn() {
        // Called after the flying airplane animation completes (see FlyingAirplaneView)
        authVM.signIn(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password) { result in
            DispatchQueue.main.async {
                isLoggingIn = false

                switch result {
                case .success:
                    // Keep the small logo faded briefly, ContentView will switch to the signed-in view
                    withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
                        logoOpacity = 1.0
                    }
                    // no further action here — AuthViewModel updates isSignedIn and ContentView reacts to it
                case .failure(let error):
                    // Show error and reset animations
                    errorMessage = error.localizedDescription
                    showErrorAlert = true

                    withAnimation(.easeInOut(duration: 0.25)) {
                        showAirplaneAnimation = false
                        logoOpacity = 1.0
                    }
                }
            }
        }
    }

    // MARK: Helpers

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

// Custom TextField style used in the form
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 2)
            )
    }
}

// MARK: - Previews
#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}

#Preview("Dark Mode") {
    LoginView()
        .preferredColorScheme(.dark)
        .environmentObject(AuthViewModel())
}
