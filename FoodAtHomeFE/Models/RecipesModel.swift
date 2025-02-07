//
//  RecipesResponse.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/5/25.
//
import Foundation

struct RecipeResponse: Codable {
    let recipe: Recipe
}

struct RecipesResponse: Codable {
    let recipe: [Recipe] 
}

struct Recipe: Codable, Identifiable {
    let id: Int
    let name: String
    let recipe_id: Int
    let image: String
    let favorite: Bool?
}

