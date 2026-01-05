//
//  AuthViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 31/12/25.
//


import Foundation
import Combine

#if canImport(FirebaseAuth) && canImport(FirebaseCore)
//import FirebaseAuth
import FirebaseCore
import Combine
import FirebaseAuth

final class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var userEmail: String?
    @Published var authErrorMessage: String?

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        addAuthStateListener()
    }

    deinit {
        removeAuthStateListener()
    }

    private func addAuthStateListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isSignedIn = (user != nil)
                self?.userEmail = user?.email
            }
        }
    }

    private func removeAuthStateListener() {
        if let h = handle {
            Auth.auth().removeStateDidChangeListener(h)
        }
    }

    // Sign in existing user
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

    // Create new user
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

    // Reset password (sends email)
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

    // Sign out
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

// Fallback stub used while FirebaseAuth / FirebaseCore is not available.
// Keeps app and previews compiling; simula comportamento básico.

final class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var userEmail: String?
    @Published var authErrorMessage: String?

    init() {}

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Simula atraso de rede
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            // Simula sucesso — ajuste lógica para testes locais
            self.isSignedIn = true
            self.userEmail = email
            completion(.success(()))
        }
    }

    func createUser(email: String, password: String, displayName: String? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.isSignedIn = true
            self.userEmail = email
            completion(.success(()))
        }
    }

    func sendPasswordReset(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion(.success(()))
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        self.isSignedIn = false
        self.userEmail = nil
        completion(.success(()))
    }
}
#endif
