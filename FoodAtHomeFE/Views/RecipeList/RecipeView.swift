//
//  RecipeView.swift
//  Food_At_Home
//
//  Created by hi on 1/28/25.
//

import SwiftUI
import SwiftData


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
                        RecipeCardView(recipeName: recipe.name, imageURL: URL(string: recipe.image),
                                       id: recipe.id,
                                       favorite: recipe.favorite,
                                       onDeleteTab: { id in
                                        deleteRecipe(id: id)
                        },
                                       onFavorite: { id in
                                        updateFavorite(id: id)
                        }
                        )
                    }
                }
            }
            .refreshable {
                await dataManager.fetchRecipes()
            }
            //            .onAppear {
            .task {
                await dataManager.fetchRecipes()
            }
            //            }
            .navigationTitle("My Recipes")
        }
    }
    private func deleteRecipe(id: Int) {
        Task {
            await dataManager.deleteRecipe(recipeID: id)
        }
    }
    private func updateFavorite(id: Int) {
        Task {
            await dataManager.updateFavorite(recipeID: id)
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

