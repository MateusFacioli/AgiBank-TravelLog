//
//  RegisterView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 31/12/25.
//


import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Full name (optional)", text: $displayName)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)

                SecureField("Password (min 6 chars)", text: $password)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)

                Button("Create Account") {
                    authVM.createUser(email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                                      password: password,
                                      displayName: displayName.isEmpty ? nil : displayName) { result in
                        switch result {
                        case .success:
                            presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            alertMessage = error.localizedDescription
                            showingAlert = true
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)

                Spacer()
            }
            .padding()
            .navigationTitle("Register")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Registration error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}