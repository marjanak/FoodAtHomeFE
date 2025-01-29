//
//  HomeView.swift
//  Food_At_Home
//
//  Created by hi on 1/28/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    
    var body: some View {
        if dataManager.signedIn {
            PantryView()
//            RecipeView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    HomeView()
        .environment(DataManager())
}
