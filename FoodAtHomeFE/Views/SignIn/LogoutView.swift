//
//  LogoutView.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/5/25.
//

import SwiftUI

struct LogoutView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to log out?")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                Task {
                    await dataManager.logout()
                }
            }) {
                Text("Logout")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 207/255, green: 92/255, blue: 54/255))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    LogoutView()
        .environment(DataManager())
}
