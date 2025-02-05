//
//  FindRecipeOption.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/3/25.
//
//
//


import SwiftUI

struct FindRecipeFormView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    @State private var ingredientsInput: String = ""
    @State private var selection = Set<Int>()
    
    var body: some View {
        NavigationStack {
            VStack() {
                List(dataManager.recipesAPI, id: \.id) { recipe in
                    NavigationLink(destination: FindRecipeView(recipe: recipe)) {
                        VStack(alignment: .leading) {
                            Text(recipe.title)
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Ready in \(recipe.readyInMinutes) minutes")
                                .font(.subheadline)
                        }
                    }
                }
                Text("Enter an ingredient to search for a recipe")
                    .font(.subheadline)

                TextField("Apple Sugar Flour", text: $ingredientsInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Text("OR")
                    .font(.headline)
                
                Text("Select pantry items to search for a recipe")
                    .font(.subheadline)
                
                List(dataManager.pantry, id: \.id, selection: $selection) { item in
                    Text(item.ingredient)
                }
                .pickerStyle(.inline)
                .environment(\.editMode, .constant(.active))
                .frame(height: 200)
                
                Button("Generate Recipe") {
                    var ingredientsToUse = ingredientsInput.trimmingCharacters(in: .whitespacesAndNewlines)
                    let selectedItems = dataManager.pantry.filter { selection.contains($0.id) }
                    let selectedNames = selectedItems.map { $0.ingredient }
                    
                    if !selectedNames.isEmpty {
                        let joinedIngredients = selectedNames.joined(separator: ",")
                        if !ingredientsToUse.isEmpty {
                            ingredientsToUse += "," + joinedIngredients
                        } else {
                            ingredientsToUse = joinedIngredients
                        }
                    }
                    
                    Task {
                        await dataManager.fetchRecipesByIngredient(with: ingredientsToUse)
                    }
                    
                    // Clear input and selection after generating the recipe
                    ingredientsInput = ""
                    selection.removeAll()
                }
                .padding(20)
                .background(Color(red: 207/255, green: 92/255, blue: 54/255))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                .task {
                    await dataManager.fetchPantry()
                }
                Spacer()
//                // Display the list of fetched recipes
//                List(dataManager.recipesAPI, id: \.id) { recipe in
//                    NavigationLink(destination: FindRecipeView(recipe: recipe)) {
//                        VStack(alignment: .leading) {
//                            Text(recipe.title)
//                                .font(.headline)
//                            Text("Ready in \(recipe.readyInMinutes) minutes")
//                                .font(.subheadline)
//                        }
//                    }
//                }
            }
            .navigationTitle("Find Recipe")
            
        }
    }
}

#Preview {
    FindRecipeFormView()
        .environment(DataManager())
}











//import SwiftUI
//
//struct FindRecipeFormView: View {
//    @Environment(DataManager.self) var dataManager: DataManager
//    @State private var ingredientsInput: String = ""
//    @State private var selection = Set<Int>()
//
//    var body: some View {
//        NavigationStack {
//            ScrollView  {
//                VStack(spacing: 30) {
//                    Spacer()
//                    TextField("Search Ingredient", text: $ingredientsInput)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal)
//
//                    Text("OR")
//                        .font(.headline)
//
//                    List(dataManager.pantry, id: \.id, selection: $selection) { item in
//                        Text(item.ingredient)
//                    }
//                    .pickerStyle(.inline)
//                    .environment(\.editMode, .constant(.active))
//                    .frame(height: 200)
//
//
//
//                    Button("Generate Recipe") {
//                        var ingredientsToUse = ingredientsInput
//                        let selectedItems = dataManager.pantry.filter { selection.contains($0.id) }
//                        let selectedNames = selectedItems.map { $0.ingredient }
//
//                        if !selectedNames.isEmpty {
//                            if !ingredientsToUse.isEmpty {
//                                ingredientsToUse += "," + selectedNames.joined(separator: ",")
//                            } else {
//                                ingredientsToUse = selectedNames.joined(separator: ",")
//                            }
//                        }
//
//                        Task {
//                            await dataManager.fetchRecipesByIngredient(with: ingredientsToUse)
//                        }
//                        ingredientsInput = ""
//                        selection.removeAll()
//                    }
//                    .padding(20)
//                    .task {
//                        await dataManager.fetchPantry()
//                    }
//
//                    List(dataManager.recipesAPI, id: \.id) { recipe in
//                        NavigationLink(destination: FindRecipeView(recipe: recipe)) {
//                            VStack(alignment: .leading) {
//                                Text(recipe.title)
//                                    .font(.headline)
//                                Text("Ready in \(recipe.readyInMinutes) minutes")
//                                    .font(.subheadline)
////                                Spacer()
//                            }
//                        }
//                    }
//                }
//                .navigationTitle("Find Recipe")
//            }
//        }
//    }
//}
//
//#Preview {
//    FindRecipeFormView()
//        .environment(DataManager())
//}
//
