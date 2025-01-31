//
//  DataManager.swift
//  Food_At_Home
//
//  Created by hi on 1/25/25.
//

import SwiftUI


@MainActor @Observable
class DataManager {
    let baseURL = URL(string: "http://127.0.0.1:5000")!
    var signedIn: Bool = false
    var pantry: [Ingredient] = []
    var recipes: [Recipe] = []
    var loginError: String = ""
    
    func signInWith(username: String, password: String) async {
        let url = URL(string: "\(baseURL)/users/login")!
        let loginRequest = LoginRequest(username: username, password: password)
        
        // Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(loginRequest)
        
        // Build Session
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            print("Data: \(data)")
            let jsonDataResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            print("Message: \(jsonDataResponse.message)")
            print("Response: \(response)")
            if jsonDataResponse.message.localizedCaseInsensitiveContains("logged in") {
                signedIn = true
            }
        } catch {
            print("Error with users/login call: \(error)")
            loginError = "Oops! We couldn't log you in. Please double-check your email and password."
        }
    }
    
    func fetchPantry() async {
        let url = URL(string: "\(baseURL)/ingredients")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            // decode
            let decodedResponse = try JSONDecoder().decode(IngredientsResponse.self, from: data)
            pantry = decodedResponse.ingredients
            print(pantry)
            
            // testing with prints
            for item in pantry {
                print("Ingredient ID: \(item.id), Name: \(item.ingredient)")
            }
            
            print("HTTP Response: \(response)")
            
        } catch {
            print("Error fetching pantry/ingredients: \(error)")
        }
    }
    
    func deleteIngredient(ingredientID: Int) async {
        let url = URL(string: "\(baseURL)/ingredients/\(ingredientID)")!
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            let jsonDataResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            print("Message: \(jsonDataResponse.message)")
            print("Response: \(response)")
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                pantry.removeAll() {$0.id == ingredientID}
                print("Ingredient \(ingredientID) deleted successfully.")
                print("HTTP Response: \(response)")
            } else {
                print("Failed to delete ingredient \(ingredientID).")
            }
        } catch {
            print("Error deleting ingredient: \(error)")
        }
    }
    
    func fetchRecipes() async {
        let url = URL(string: "\(baseURL)/recipes/all")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            let decodedResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
            recipes = decodedResponse.recipe
            for recipe in recipes {
                print("Recipe ID: \(recipe.id), Name: \(recipe.name), Image: \(recipe.image), Recipe ID: \(recipe.recipe_id)")
            }
            print("HTTP Response: \(response)")
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
    
    func deleteRecipe(recipeID: Int) async {
        let url = URL(string: "\(baseURL)/recipes/\(recipeID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            let jsonDataResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            print("Message: \(jsonDataResponse.message)")
            print("Response: \(response)")
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                recipes.removeAll() {$0.id == recipeID}
                print("Ingredient \(recipeID) deleted successfully.")
                print("HTTP Response: \(response)")
            } else {
                print("Failed to delete recipe \(recipeID).")
            }
        } catch {
            print("Error deleting recipe: \(error)")
        }
    }
    
}
