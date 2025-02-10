//
//  AddIngredientsResponse.swift
//  FoodAtHomeFE
//
//  Created by hi on 2/5/25.
//
import Foundation

struct ErrorResponse: Codable {
    let message: String
}

struct Ingredient: Codable, Identifiable {
    let id: Int
    let ingredient: String
    let expiration_date: String?
}

struct IngredientsResponse: Codable {
    let ingredients: [Ingredient]
}

struct IngredientRequest: Codable {
    let ingredient: String
    let expirationDate: String?
}

struct AddIngredientsResponse: Codable {
    let message: String
    let ingredient: Ingredient
}

struct UserIngredient: Codable {
    let expiration_date: String
}
