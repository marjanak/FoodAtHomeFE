//
//  RecipesAPIResponse.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/5/25.
//
import Foundation

struct RecipesAPIResponse: Codable {
    let recipes: [RecipeAPI]
}

// Recipe model with the fields you want to capture
struct RecipeAPI: Codable, Identifiable {
    let extendedIngredients: [ExtendedIngredient]
    let id: Int
    let image: String
    let instructions: [String]
    let missedIngredients: [String]
    let readyInMinutes: Int
    let servings: Int
    let summary: String
    let title: String
}

// Model for each extended ingredient
struct ExtendedIngredient: Codable {
    let amount: Double
    let nameClean: String
    let original: String
    let unit: String
}
