//
//  FindRecipeView.swift
//  FoodAtHomeFE
//
//  Created by hi on 1/31/25.




import SwiftUI

struct FindRecipeView: View {
    let recipe: RecipeAPI
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                
                Text("Ready in \(recipe.readyInMinutes) minutes")
                    .font(.subheadline)
                
                Text("Servings: \(recipe.servings)")
                    .font(.subheadline)
                
                Text("Summary:")
                    .font(.headline)
                
                HTMLStringView(htmlContent: recipe.summary)
                    .font(.body)
                Text(recipe.summary)
                
                // Ingredients Section
                Text("Ingredients:")
                    .font(.headline)
                ForEach(recipe.extendedIngredients, id: \.original) { ingredient in
                    Text("• \(ingredient.original)")
                        .font(.body)
                }
                
                // Instructions Section
                Text("Instructions:")
                    .font(.headline)
                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
                    Text("\(index + 1). \(step)")
                        .font(.body)
                }
                
            }
            .padding()
        }
        .navigationTitle(recipe.title)
    }
}


//#Preview {
//    FindRecipeView(recipe: <#[RecipeAPI]#>)
//}
