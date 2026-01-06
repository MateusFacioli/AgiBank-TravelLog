//
//  AuthViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 31/12/25.
//

/**
 ViewModel responsável por gerenciar autenticação de usuários.
 
 - Encapsula operações comuns como login, criação de conta, envio de e-mail de redefinição de senha e logout.
 - Observa mudanças de sessão do FirebaseAuth para manter `isSignedIn` e `userEmail` sincronizados com a UI.
 - Quando FirebaseAuth/FirebaseCore não estão disponíveis (ex.: Previews, builds sem dependências), um stub interno é utilizado
   para manter a aplicação compilando e permitir testes básicos de fluxo.
 
 O uso de `@Published` garante que SwiftUI reaja às alterações de estado em tempo real.
 */

import Foundation
import Combine

#if canImport(FirebaseAuth) && canImport(FirebaseCore)
//import FirebaseAuth
import FirebaseCore
import Combine
import FirebaseAuth
/// Implementação real baseada em FirebaseAuth. Requer que os módulos `FirebaseAuth` e `FirebaseCore` estejam disponíveis
/// no alvo atual. Atualiza automaticamente `isSignedIn` e `userEmail` conforme o estado de autenticação muda.
final class AuthViewModel: ObservableObject {
    /// Indica se há um usuário autenticado na sessão atual.
    @Published var isSignedIn: Bool = false
    /// E-mail do usuário autenticado (se houver).
    @Published var userEmail: String?
    /// Mensagem de erro de autenticação amigável para exibição na UI.
    @Published var authErrorMessage: String?

    /// Handle do listener de mudanças de estado de autenticação do Firebase.
    private var handle: AuthStateDidChangeListenerHandle?

    /// Inicializa a ViewModel e registra o listener de mudanças de autenticação.
    init() {
        addAuthStateListener()
    }

    /// Remove o listener ao desalocar para evitar vazamentos e callbacks indevidos.
    deinit {
        removeAuthStateListener()
    }

    /// Adiciona um listener para sincronizar `isSignedIn` e `userEmail` sempre que o Firebase notificar mudanças.
    private func addAuthStateListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isSignedIn = (user != nil)
                self?.userEmail = user?.email
            }
        }
    }

    /// Remove o listener de mudanças de autenticação, se existente.
    private func removeAuthStateListener() {
        if let h = handle {
            Auth.auth().removeStateDidChangeListener(h)
        }
    }

    /// Realiza login de um usuário existente.
    /// - Parameters:
    ///   - email: E-mail do usuário.
    ///   - password: Senha do usuário.
    ///   - completion: Callback com sucesso ou erro de autenticação.
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authErrorMessage = nil
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.authErrorMessage = error.localizedDescription
                    completion(.failure(error))
                    return
                }
                self?.isSignedIn = authResult?.user != nil
                self?.userEmail = authResult?.user.email
                completion(.success(()))
            }
        }
    }

    /// Cria um novo usuário e, opcionalmente, atualiza o `displayName` do perfil.
    /// - Parameters:
    ///   - email: E-mail a ser cadastrado.
    ///   - password: Senha do novo usuário.
    ///   - displayName: Nome de exibição opcional para o perfil do usuário.
    ///   - completion: Callback indicando sucesso ou erro.
    func createUser(email: String, password: String, displayName: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        authErrorMessage = nil
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.authErrorMessage = error.localizedDescription
                    completion(.failure(error))
                    return
                }
                // Update profile (displayName) if provided
                if let name = displayName, let user = Auth.auth().currentUser {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges { err in
                        if let err = err {
                            // non-fatal: user created but profile update failed
                            self?.authErrorMessage = err.localizedDescription
                        }
                        self?.isSignedIn = Auth.auth().currentUser != nil
                        self?.userEmail = Auth.auth().currentUser?.email
                        completion(.success(()))
                    }
                } else {
                    self?.isSignedIn = authResult?.user != nil
                    self?.userEmail = authResult?.user.email
                    completion(.success(()))
                }
            }
        }
    }

    /// Envia e-mail de redefinição de senha para o endereço informado.
    /// - Parameters:
    ///   - email: E-mail que receberá o link de redefinição.
    ///   - completion: Callback indicando sucesso ou erro.
    func sendPasswordReset(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authErrorMessage = nil
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.authErrorMessage = error.localizedDescription
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }

    /// Finaliza a sessão do usuário atual.
    /// - Parameter completion: Callback indicando sucesso ou erro ao encerrar a sessão.
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isSignedIn = false
                self.userEmail = nil
            }
            completion(.success(()))
        } catch {
            authErrorMessage = error.localizedDescription
            completion(.failure(error))
        }
    }
}

#else

/// Implementação stub usada quando `FirebaseAuth`/`FirebaseCore` não estão disponíveis.
/// Mantém a aplicação e Previews compilando e permite testar fluxos básicos sem backend real.
final class AuthViewModel: ObservableObject {
    /// Indica se há um usuário autenticado na sessão simulada.
    @Published var isSignedIn: Bool = false
    /// E-mail do usuário autenticado na simulação (se houver).
    @Published var userEmail: String?
    /// Mensagem de erro simulada para feedback na UI.
    @Published var authErrorMessage: String?

    /// Inicializador padrão do stub (não registra listeners reais).
    init() {}

    /// Simula login bem-sucedido após pequeno atraso.
    /// - Parameters:
    ///   - email: E-mail do usuário.
    ///   - password: Senha do usuário.
    ///   - completion: Callback com resultado da simulação.
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Simula atraso de rede
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            // Simula sucesso — ajuste lógica para testes locais
            self.isSignedIn = true
            self.userEmail = email
            completion(.success(()))
        }
    }

    /// Simula criação de usuário e autenticação imediata.
    /// - Parameters:
    ///   - email: E-mail a ser cadastrado.
    ///   - password: Senha do novo usuário.
    ///   - displayName: Nome de exibição opcional (ignorado na simulação).
    ///   - completion: Callback com resultado da simulação.
    func createUser(email: String, password: String, displayName: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.isSignedIn = true
            self.userEmail = email
            completion(.success(()))
        }
    }

    /// Simula envio de e-mail de redefinição de senha.
    /// - Parameters:
    ///   - email: E-mail que receberia o link de redefinição.
    ///   - completion: Callback com resultado da simulação.
    func sendPasswordReset(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion(.success(()))
        }
    }

    /// Simula encerramento de sessão limpando estado local.
    /// - Parameter completion: Callback com resultado da simulação.
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        self.isSignedIn = false
        self.userEmail = nil
        completion(.success(()))
    }
}
#endif

