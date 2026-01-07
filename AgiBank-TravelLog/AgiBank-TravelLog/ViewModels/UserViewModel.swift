//
//  UserViewModel.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 06/01/26.
//


import SwiftUI

class UserViewModel: ObservableObject {
    @Published var nome = ""
    @Published var email = ""
    @Published var isLoggedIn = false
    
    func login() {
        if !nome.isEmpty && !email.isEmpty {
            isLoggedIn = true
            print("Usuário \(nome) logado com sucesso!")
        }
    }
    
    func logout() {
        isLoggedIn = false
        nome = ""
        email = ""
        print("Usuário deslogado")
    }
}
