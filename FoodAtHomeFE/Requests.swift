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

struct IngredientsResponse: Codable {
    let ingredients: [Ingredient]
}

struct Ingredient: Codable, Identifiable {
    let id: Int
    let ingredient: String
}

struct RecipesResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let id: Int
    let name: String
    let recipe_id: Int
    let foodie_id: Int
}
