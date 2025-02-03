//
//  FindRecipeView.swift
//  FoodAtHomeFE
//
//  Created by hi on 1/31/25.




import SwiftUI

struct FindRecipeOpt: View {
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
                Text(recipe.summary)
                    .font(.body)
                
                // You can add additional recipe details here
            }
            .padding()
        }
        .navigationTitle(recipe.title)
    }
}








//import SwiftUI
//
//struct FindRecipeOpt: View {
//    @Environment(DataManager.self) var dataManager: DataManager
//    @State private var ingredient = ""
//    @State var recipe: [RecipeAPI]
//    
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}


//#Preview {
//    FindRecipeOpt(recipe: <#[RecipeAPI]#>)
//}
