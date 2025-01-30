//
//  SwiftUIView.swift
//  Food_At_Home
//
//  Created by hi on 1/25/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    
    @State var username: String = "izzy"
    @State var password: String = "securepassword123"
    @State private var isRegistering = false

    var body: some View {
        VStack(spacing: 20) {
            Text(isRegistering ? "Register" : "Login")
                .font(.largeTitle)
            
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            SecureField("Password", text: $password)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button(isRegistering ? "Register" : "Login") {
                print("Continuing with username: \(username) password: \(password)")
                Task {
                    await dataManager.signInWith(username: username, password: password)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environment(DataManager())
}
