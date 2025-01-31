//
//  ContentView.swift
//  FoodAtHomeFE
//
//  Created by New Student on 1/28/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    
    var body: some View {
        if dataManager.signedIn {
            TabView {
                RecipeView()
                        .tabItem {
                            Label("My Recipes",
                                  systemImage: "fork.knife.circle")
                        }
                PantryView()
                    .tabItem {
                        Label("My Pantry",
                              systemImage: "carrot.fill")
                    }

                FindRecipeView()
                        .tabItem {
                            Label("Find Recipes",
                                  systemImage: "magnifyingglass")
                        }
                RecipeView()
                        .tabItem {
                            Label("Notes",
                                  systemImage: "square.and.pencil")
                        }
                }
            
//
        } else {
            LoginView()
        }
        
        

        
    }
}

#Preview {
    ContentView()
        .environment(DataManager())
}
