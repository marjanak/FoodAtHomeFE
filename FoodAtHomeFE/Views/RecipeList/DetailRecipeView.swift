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
                              Image(systemName: "note.text.badge.plus")
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
