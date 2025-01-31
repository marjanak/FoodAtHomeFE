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
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .padding()

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
                Task {
                    await dataManager.signInWith(username: username, password: password)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 207/255, green: 92/255, blue: 54/255))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text(dataManager.loginError)
                .foregroundColor(.red)
                .padding()
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environment(DataManager())
}
