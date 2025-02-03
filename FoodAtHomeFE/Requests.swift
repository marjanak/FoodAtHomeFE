//
//  Requests.swift
//  Food_At_Home
//
//  Created by hi on 1/25/25.
//

import Foundation

struct LoginRequest: Codable{
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let message: String
}

//pantry add
struct AddIngredientsResponse: Codable {
    let message: String
    let ingredient: Ingredient
}

//pantry add
struct IngredientRequest: Codable {
    let name: String
}

struct IngredientsResponse: Codable {
    let ingredients: [Ingredient]
}

struct Ingredient: Codable, Identifiable {
    let id: Int
    let ingredient: String
}

struct RecipesResponse: Codable {
    let recipe: [Recipe] 
}

struct Recipe: Codable, Identifiable {
    let id: Int
    let name: String
    let recipe_id: Int
    let image: String
}

struct RecipesAPIResponse: Codable {
    let recipes: [RecipeAPI]
}

// Recipe model with the fields you want to capture
struct RecipeAPI: Codable {
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
