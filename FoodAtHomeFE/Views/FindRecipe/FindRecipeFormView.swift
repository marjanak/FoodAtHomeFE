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
    @State private var selectedOptions: Set<String> = []

    var body: some View {
        NavigationStack {
            Form {
                Section("Enter ingredients to search for a recipe"){
                    TextField("Apple Sugar", text: $ingredientsInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                Section("Select pantry items to search for a recipe") {
                    MultiSelectDropdownMenu(selectedOptions: $selectedOptions)
                }

                Button("Generate Recipe") {
                    var ingredientsToUse = ingredientsInput.trimmingCharacters(in: .whitespacesAndNewlines)
                    let selectedIngredients = Array(selectedOptions)
                    
                    if !selectedIngredients.isEmpty {
                        let joinedIngredients = selectedIngredients.joined(separator: ",")
                        if !ingredientsToUse.isEmpty {
                            ingredientsToUse += "," + joinedIngredients
                        } else {
                            ingredientsToUse = joinedIngredients
                        }
                    }
                    Task {
                        await dataManager.fetchRecipesByIngredient(with: ingredientsToUse)
                    }
                    ingredientsInput = ""
                    selectedOptions.removeAll()
                }
                .padding(20)
                .background(Color(red: 207/255, green: 92/255, blue: 54/255))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
                
                .alert("Error", isPresented: Binding<Bool>(
                    get: { dataManager.showAlertRecipeForm },
                    set: { dataManager.showAlertRecipeForm = $0 }
                )) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(dataManager.errorMsg)
                }
                
                List(dataManager.recipesAPI, id: \.id) { recipe in
                    NavigationLink(destination: FindRecipeView(recipe: recipe, saveClicked: false)) {
                        VStack(alignment: .leading) {
                            Text(recipe.title)
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Ready in \(recipe.readyInMinutes) minutes")
                                .font(.subheadline)
                        }
                    }
                    padding(.vertical)
                }
            }
            .navigationTitle("Find Recipes")
            .task {
                await dataManager.fetchPantry()
            }
        }
    }
}
