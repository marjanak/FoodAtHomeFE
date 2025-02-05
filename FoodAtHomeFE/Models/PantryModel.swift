//
//  AddIngredientsResponse.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/5/25.
//
import Foundation

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
