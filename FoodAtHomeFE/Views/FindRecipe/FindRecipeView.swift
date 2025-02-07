//
//  FindRecipeView.swift
//  FoodAtHomeFE
//
//  Created by hi on 1/31/25.




import SwiftUI

struct FindRecipeView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    let recipe: RecipeAPI
    @State var saveClicked: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(recipe.title)
                    .font(.title)
                    .bold()
                
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
                
                Spacer()
                
                Text("Ingredients:")
                    .font(.headline)
                ForEach(recipe.extendedIngredients, id: \.original) { ingredient in
                    HStack {
                        Text("• \(ingredient.original)")
                            .font(.body)
                        Spacer()
                        Button(action: {
                            Task {
                                await dataManager.addShoppingNote(note: ingredient.original)
                            }
                        }) {
                            Image(systemName: "cart.fill.badge.plus")
                        }
                    }
                }
                
                Spacer()
                
                Text("Instructions:")
                    .font(.headline)
                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
                    Text("\(index + 1). \(step)")
                        .font(.body)
                }
                
            }
            .padding()
        }
        .toolbar {
            Button(saveClicked ? "Saved" : "Save") {
                addRecipe()
                saveClicked = true
            }
            .padding(.horizontal)
            .background(Color(red: 207/255, green: 92/255, blue: 54/255))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    private func addRecipe() {
        Task {
            await dataManager.addRecipeItem(name: recipe.title, recipe_id: recipe.id, image: recipe.image)
        }
    }
}


//#Preview {
//    FindRecipeView(recipe: <#[RecipeAPI]#>)
//}
