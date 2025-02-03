//
//  FindRecipeOption.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/3/25.
//


import SwiftUI

struct FindRecipeView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    @State private var ingredient: String = ""
    @State private var selection = Set<Int>()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                TextField("Add Ingredients", text: $ingredient)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Text("OR")
                    .font(.headline)
                
                
                
                List(dataManager.pantry, id: \.id, selection: $selection) { item in
                    Text(item.ingredient)
                }
                .pickerStyle(.inline)
                .environment(\.editMode, .constant(.active))
                .frame(height: 200)
                
                
                
                Button("Generate") {
                    var ingredientsToUse = ingredient
                    let selectedItems = dataManager.pantry.filter { selection.contains($0.id) }
                    let selectedNames = selectedItems.map { $0.ingredient }
                    
                    if !selectedNames.isEmpty {
                        if !ingredientsToUse.isEmpty {
                            ingredientsToUse += "," + selectedNames.joined(separator: ",")
                        } else {
                            ingredientsToUse = selectedNames.joined(separator: ",")
                        }
                    }
                    
                    Task {
                        await dataManager.fetchRecipesByIngredient(with: ingredientsToUse)
                    }
                    ingredient = ""
                    selection.removeAll()
                }
                .padding(20)
                .task {
                    await dataManager.fetchPantry()
                }
                
                List(dataManager.recipesAPI, id: \.id) { recipe in
                    NavigationLink(destination: FindRecipeOpt(recipe: recipe)) {
                        VStack(alignment: .leading) {
                            Text(recipe.title)
                                .font(.headline)
                            Text("Ready in \(recipe.readyInMinutes) minutes")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Find Recipe")
        }
    }
}

#Preview {
    FindRecipeView()
        .environment(DataManager())
}




//import SwiftUI
//
//
//struct FindRecipeView: View {
//    @Environment(DataManager.self) var dataManager: DataManager
//    @State private var ingredient: String = ""
//    @State private var selection = Set<Int>()
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 16) {
//                TextField("Add Ingredients", text: $ingredient)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//                Text("OR")
//
//                ForEach(dataManager.pantry, id: \.id, selection: $selection) {
//                    ingredient in ingredient.ingredient
//                }
//                Button("Generate") {
//                    Task {
//                        await dataManager.fetchRecipesByIngredient(with: ingredient)
//                    }
//                    ingredient = ""
//                }
//                .padding()
//                .task{
//                    await dataManager.fetchPantry()
//                }
//                // Display a list of fetched recipes
//                List(dataManager.recipesAPI, id: \.id) { recipe in
//                    VStack(alignment: .leading) {
//                        Text(recipe.title)
//                            .font(.headline)
//                        Text("Ready in \(recipe.readyInMinutes) minutes")
//                            .font(.subheadline)
//                    }
//                }
//            }
//            .navigationTitle("Find Recipe")
//        }
//    }
//}
//
//#Preview {
//    FindRecipeView()
//        .environment(DataManager())
//}
