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
        if dataManager.signedIn || dataManager.registered {
            TabView {
                Group {
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
                    FindRecipeFormView()
                        .tabItem {
                            Label("Find Recipes",
                                  systemImage: "magnifyingglass")
                        }
                    ShoppingList()
                        .tabItem {
                            Label("Notes",
                                  systemImage: "square.and.pencil")
                        }
                    LogoutView()
                        .tabItem {
                            Label("Logout",
                                  systemImage: "rectangle.portrait.and.arrow.right.fill")
                        }
                    
                }
                .toolbarBackground(.green, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.light, for: .tabBar)
                //.background(Color(red: 140/255, green: 195/255, blue: 66/255))
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environment(DataManager())
}
