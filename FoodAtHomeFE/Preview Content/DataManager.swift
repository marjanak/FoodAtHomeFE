//
//  DataManager.swift
//  Food_At_Home
//
//  Created by hi on 1/25/25.
//

import SwiftUI


@Observable
class DataManager {
    let baseURL = URL(string: "http://127.0.0.1:5000")!
    var signedIn: Bool = false
    var pantry: [Ingredient] = []
    var recipes: [Recipe] = []
    
    func signInWith(username: String, password: String) async {
        let url = URL(string: "\(baseURL)/users/login")!
        
        // Body of the Request
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
            
            // testing with prints
            for item in pantry {
                print("Ingredient ID: \(item.id), Name: \(item.ingredient)")
            }
            
            print("HTTP Response: \(response)")
            
        } catch {
            print("Error fetching pantry/ingredients: \(error)")
        }
    }
    
    func fetchRecipes() async {
        let url = URL(string: "\(baseURL)/all")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            
            // Decode the response
            let decodedResponse = try JSONDecoder().decode([Recipe].self, from: data)
            
            // Assuming you have a variable to store the recipes
            recipes = decodedResponse
            
            // Testing with prints
            for recipe in recipes {
                print("Recipe ID: \(recipe.id), Name: \(recipe.name), Recipe ID: \(recipe.recipe_id), Foodie ID: \(recipe.foodie_id)")
            }
            
            print("HTTP Response: \(response)")
            
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
    
}

