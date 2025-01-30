//
//  RecipeCardView.swift
//  Food_At_Home
//
//  Created by hi on 1/28/25.
//

import SwiftUI

struct RecipeCardView: View {
    let recipeName: String
    let imageURL: URL?
    
    var body: some View {
        ZStack {
            NavigationLink(destination: DetailRecipeView(recipeName: recipeName)) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: 200, maxHeight: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        //                        .clipped()
                    case .failure:
                        Image(systemName: "photo.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 200, maxHeight: 100)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            .frame(width: 150, height: 150)
            

                Text(recipeName)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .padding()
                    .background(
                        .thinMaterial
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            
        }
    }
}

//#Preview {
//    RecipeCardView(
//        recipeName: "Spaghetti with Meatballs",
//        imageURL: URL(string: "https://img.spoonacular.com/recipes/673463-312x231.jpg")
//    )
//}
