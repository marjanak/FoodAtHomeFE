//
//  DetailRecipeView.swift
//  Food_At_Home
//
//  Created by hi on 1/28/25.
//

//import SwiftUI
//
//struct DetailRecipeView: View {
//    var recipeName: String
//    
//    var body: some View {
//        VStack {
//            Text(recipeName)
//            Text("Placeholder for description")
//            Text("Placeholder for other data?")
//        }
//    }
//}
//
//#Preview {
//    DetailRecipeView(recipeName: "Check all windows")
//}

import SwiftUI

struct DetailRecipeView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    let recipeID: Int
    
    var body: some View {
        VStack {
            if let recipe = dataManager.recipedata {
                AsyncImage(url: URL(string: recipe.image)) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                }
                .padding()
                
                Text(recipe.title)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Ready in \(recipe.readyInMinutes) minutes")
                    .font(.headline)
                    .foregroundColor(.secondary)
                           
                Text("Ingredients:")
                    .font(.headline)
                    .bold()
                    .padding(.top, 10)
                ForEach(recipe.extendedIngredients, id: \.original) { ingredient in
                    Text("\(ingredient.original)")
                        .font(.body)
                }
                .frame(height: 200)
                
                Text("Instructions")
                    .font(.title2)
                    .bold()
                    .padding(.top, 10)
                
                ScrollView {
                    Text(recipe.instructions)
                        .padding()
                        .multilineTextAlignment(.leading)
                }
            } else {
                ProgressView("Loading Recipe...")
            }
        }
        .onAppear {
            Task {
                await dataManager.fetchdetailrecipe(id: recipeID)
            }
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
