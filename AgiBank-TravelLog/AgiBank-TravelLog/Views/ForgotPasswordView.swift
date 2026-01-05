//
//  ForgotPasswordView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 31/12/25.
//


import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Enter the email address for your account and we'll send a password reset email.")
                    .font(.subheadline)
                    .padding(.bottom)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)

                Button("Send Password Reset") {
                    authVM.sendPasswordReset(email: email.trimmingCharacters(in: .whitespacesAndNewlines)) { result in
                        switch result {
                        case .success:
                            alertMessage = "Password reset email sent. Check your inbox."
                            showingAlert = true
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
            .navigationTitle("Reset Password")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    // Optionally close on success
                })
            }
        }
    }
}