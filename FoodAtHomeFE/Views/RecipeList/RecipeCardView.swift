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
    let id: Int
    let favorite: Bool
    var onDeleteTab: (Int) -> Void
    var onFavorite: (Int) -> Void
    var recipeId : Int
    
    var body: some View {
        ZStack {
            NavigationLink(destination: DetailRecipeView(recipeId: recipeId)) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                        
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                    case .failure:
                        Image(systemName: "photo.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            .frame(width: 200, height: 150)
            .overlay (alignment: .topTrailing) {
                Button("", systemImage: "x.circle.fill") {
                    onDeleteTab(id)
                }
                .padding(0.25)
                .background(Circle()
                    .fill(Color(red: 207/255, green: 92/255, blue: 54/255)))
                .foregroundColor(.white)
                .imageScale(.large)
                
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    onFavorite(id)
                } label: {
                    Image(systemName: favorite ? "star.circle.fill" : "star.circle.fill")
                        .foregroundColor(favorite ? .orange : .black)
                        .background(
                            .thinMaterial
                        )
                }
                .padding(0.25)
                .imageScale(.large)
            }
            
            Text(recipeName)
                .font(.caption)
                .foregroundStyle(.primary)
                .padding()
                .background(
                    .thinMaterial
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: 200, maxHeight: 150)
            
        }
        .clipped()
    }
}

