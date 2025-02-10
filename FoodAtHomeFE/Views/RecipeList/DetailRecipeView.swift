import SwiftUI

struct DetailRecipeView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    let recipeId: Int
    
    var body: some View {
        ScrollView {
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
                Text("Total Ingredients: \(recipe.extendedIngredients.count)")
                
              VStack(alignment: .leading, spacing: 5) {
                                        ForEach(recipe.extendedIngredients.indices, id: \.self) { index in
                                            HStack(alignment: .top) {
                                                Text("• ")
                                                Text(recipe.extendedIngredients[index].original)
                                            }
                                        }
                                    }
                
                
                Text("Instructions")
                    .font(.title2)
                    .bold()
                    .padding(.top, 10)
                
                ScrollView {
                    Text(recipe.instructions.joined(separator: "\n"))
                        .padding()
                        .multilineTextAlignment(.leading)
                }
            } else {
                ProgressView("Loading Recipe...")
            }
        }
        }
        .onAppear {
            Task {
                await dataManager.fetchdetailrecipe(id: recipeId)
            }
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
