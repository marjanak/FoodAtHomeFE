//
//  RecipeView.swift
//  Food_At_Home
//
//  Created by hi on 1/28/25.
//

import SwiftUI


struct RecipeView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(),
                    GridItem()
                ],
                spacing: 19)
                {
                    ForEach(dataManager.recipes, id: \.id) { recipe in
                        RecipeCardView(recipeName: recipe.name, imageURL: URL(string: recipe.image))
                    }
                }
            }
            .onAppear {
                Task {
                    await dataManager.fetchRecipes()
                }
            }
            .navigationTitle("My Recipes")
            .toolbar {
                HStack {
                    Button("Find Pantry Recipe") {
                        print("Pressed Find Pantry Recipe")
                    }
                    Button("Find Recipe") {
                        print("Pressed Find Recipe")
                    }
                }
            }
        }
    }
}



#Preview {
    RecipeView()
        .environment(DataManager())
}

#Preview("RecipeView Landscape", traits: .landscapeRight, body: {
    RecipeView()
        .environment(DataManager())
})

