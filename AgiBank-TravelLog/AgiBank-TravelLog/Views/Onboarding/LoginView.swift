//
//  LoginView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 17/12/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var isLoggingIn = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToMain = false
    @FocusState private var focusedField: Field?
    @State private var showAirplaneAnimation = false
    @State private var logoOpacity: Double = 1.0
    
    enum Field {
        case username, password
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fundo gradiente
                LinearGradient(
                    colors: [
                        Color(red: 0.1, green: 0.3, blue: 0.6),
                        Color(red: 0.2, green: 0.4, blue: 0.8),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(spacing: 20) {
                            ZStack {
                                if !showAirplaneAnimation {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    .white.opacity(0.2),
                                                    .white.opacity(0.1),
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: "airplane")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                } else {
                                    FlyingAirplaneView {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            performLogin()
                                        }
                                    }
                                    .frame(width: 80, height: 80)
                                }
                            }
                            .padding(.top, 40)
                            .opacity(logoOpacity)
                            
                            VStack(spacing: 4) {
                                Text("Travel Log")
                                    .font(
                                        .system(
                                            size: 28,
                                            weight: .bold,
                                            design: .rounded
                                        )
                                    )
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text("Sua jornada começa aqui")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.bottom, 40)
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 20) {
                            // Campo de usuário
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Usuário")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                
                                TextField("Digite seu usuário", text: $username)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($focusedField, equals: .username)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .password
                                    }
                            }
                            
                            // Campo de senha
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Senha")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                
                                ZStack(alignment: .trailing) {
                                    if showPassword {
                                        TextField(
                                            "Digite sua senha",
                                            text: $password
                                        )
                                        .textFieldStyle(CustomTextFieldStyle())
                                    } else {
                                        SecureField(
                                            "Digite sua senha",
                                            text: $password
                                        )
                                        .textFieldStyle(CustomTextFieldStyle())
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            showPassword.toggle()
                                        }) {
                                            Image(
                                                systemName: showPassword
                                                    ? "eye.slash.fill"
                                                    : "eye.fill"
                                            )
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 12)
                                        }
                                    }
                                }
                                .focused($focusedField, equals: .password)
                                .submitLabel(.done)
                                .onSubmit {
                                    validateAndStartLogin()
                                }
                            }
                            
                            // Esqueci minha senha
                            HStack {
                                Spacer()
                                Button("Esqueci minha senha") {
                                    // TODO: Ação para recuperar senha
                                }
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.top, 8)
                            }
                            
                            // Botão de login
                            Button(action: {
                                validateAndStartLogin()
                            }) {
                                HStack {
                                    if isLoggingIn {
                                        ProgressView()
                                            .progressViewStyle(
                                                CircularProgressViewStyle(
                                                    tint: .white
                                                )
                                            )
                                    } else {
                                        Text("Entrar")
                                            .font(
                                                .system(
                                                    size: 18,
                                                    weight: .semibold
                                                )
                                            )
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [
                                            .blue,
                                            Color(
                                                red: 0.2,
                                                green: 0.4,
                                                blue: 0.8
                                            ),
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(
                                    color: .black.opacity(0.2),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                            }
                            .disabled(isLoggingIn || showAirplaneAnimation)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            
                            // Cadastre-se
                            HStack(spacing: 4) {
                                Text("Não tem uma conta?")
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Button("Cadastre-se") {
                                    // TODO: Navegar para tela de cadastro
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.1))
                                .shadow(
                                    color: .black.opacity(0.1),
                                    radius: 10,
                                    x: 0,
                                    y: 5
                                )
                        )
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 40)
                        
                        // Footer
                        VStack(spacing: 4) {
                            Text("© 2025 M.R.F Travel Log")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("Versão 1.0.0")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.vertical, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .contentMargins(.top, 20)
                
                // Navegação para a tela principal
                NavigationLink(
                    destination: TravelView()
                        .navigationBarBackButtonHidden(true),
                    isActive: $navigateToMain
                ) {
                    EmptyView()
                }
            }
            .alert("Erro no Login", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            // Adiciona gesture para esconder teclado
            .onTapGesture {
                hideKeyboard()
            }
//            .onAppear {
//                AppIconGenerator.generateAppIcon()
//            }
        }
    }
    
    private func validateAndStartLogin() {
        // Validação dos campos
        let validationError = validateFields()
        
        if let error = validationError {
            errorMessage = error
            showError = true
            return
        }
        
        // Se validação passar, inicia o processo de login
        startLoginProcess()
    }
    
    private func validateFields() -> String? {
        // Validação simples
        guard !username.isEmpty else {
            return "Por favor, digite seu usuário"
        }
        
        guard !password.isEmpty else {
            return "Por favor, digite sua senha"
        }
        
        if username.count < 3 {
            return "O usuário deve ter pelo menos 3 caracteres"
        }
        
        if password.count < 4 {
            return "A senha deve ter pelo menos 4 caracteres"
        }
        
        return nil // Nenhum erro
    }
    
    private func startLoginProcess() {
        hideKeyboard()
        isLoggingIn = true
        
        // Desabilita os campos durante o login
        withAnimation(.easeInOut(duration: 0.3)) {
            showAirplaneAnimation = true
        }
    }
    
    private func performLogin() {
        // Simula processo de login após a animação
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoggingIn = false
            
            // Validação de credenciais
            if isValidCredentials() {
                navigateToMain = true
            } else {
                // Credenciais inválidas
                showError = true
                errorMessage = "Usuário ou senha inválidos"
                
                // Reseta a animação
                withAnimation(.easeInOut(duration: 0.3)) {
                    showAirplaneAnimation = false
                }
            }
        }
    }
    
    private func isValidCredentials() -> Bool {
        // Para teste, aceita qualquer combinação
        // Em produção, validaria com API
        return true
        
        // Para validação específica:
        // return username.lowercased() == "matt" && password == "123"
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

// Custom TextField Style para melhor aparência
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
            )
    }
}

#Preview {
    LoginView()
}

#Preview("Dark Mode") {
    LoginView()
        .preferredColorScheme(.dark)
}

#Preview("Com teclado") {
    LoginView()
        .previewDisplayName("Com teclado aberto")
}
