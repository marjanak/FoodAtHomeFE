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
    var registered: Bool = false
    var pantry: [Ingredient] = []
    var recipes: [Recipe] = []
    var loginError: String = ""
    var recipesAPI: [RecipeAPI] = []
    var shoppinglist : [ShoppingNote] = []
    
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
            let jsonDataResponse = try JSONDecoder().decode(Response.self, from: data)
            print("Message: \(jsonDataResponse.message)")
            print("Response: \(response)")
            if jsonDataResponse.message.localizedCaseInsensitiveContains("logged in") {
                signedIn = true
            }
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode != 200){
                    loginError = "Oops! We couldn't log you in. Please double-check your email and password."
                }else{
                    loginError = ""
                }
            }
        } catch {
            print("Error with users/login call: \(error)")
            loginError = "Oops! We couldn't log you in. Please double-check your email and password."
        }
    }
    
    func register(username: String, password: String) async {
        let url = URL(string: "\(baseURL)/users/register")!
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
            let jsonDataResponse = try JSONDecoder().decode(Response.self, from: data)
            print("Message: \(jsonDataResponse.message)")
            print("Response: \(response)")
            if jsonDataResponse.message.localizedCaseInsensitiveContains("created") {
                registered = true
            }
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode != 200){
                    loginError = "Registration failed. Please try again."
                }
            }
        } catch {
            print("Error with users/registration call: \(error)")
            loginError = "Registration failed. Please try again."
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
            let jsonDataResponse = try JSONDecoder().decode(Response.self, from: data)
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
            let jsonDataResponse = try JSONDecoder().decode(Response.self, from: data)
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
    
    
    func addPantryItem(pantryItem: String) async {
        let url = URL(string: "\(baseURL)/ingredients")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(IngredientRequest(name: pantryItem))
        
        // Build Session
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            print("Data: \(data)")
            let jsonDataResponse = try JSONDecoder().decode(AddIngredientsResponse.self, from: data)
//            print("Message: \(jsonDataResponse.message)")
            print("Response: \(response)")
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200 || httpResponse.statusCode == 201){
                    let ingredient = jsonDataResponse.ingredient
                    pantry.append(ingredient)
                }else{
//                    loginError = ""
                }
            }
        } catch {
            print("Error with users/login call: \(error)")
            loginError = " We couldn't log you in. Please double-check your email and password."
        }
    }
    
    func fetchRecipesByIngredient(with ingredients: String) async {
        guard var components = URLComponents(url: baseURL.appendingPathComponent("recipes"), resolvingAgainstBaseURL: false) else {
            print("Failed to create URL components")
            return
        }
        components.queryItems = [
            URLQueryItem(name: "includeIngredients", value: ingredients)
        ]
        guard let url = components.url else {
            print("Invalid URL after adding query items")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decodedResponse = try JSONDecoder().decode(RecipesAPIResponse.self, from: data)
                self.recipesAPI = decodedResponse.recipes
                
                if !self.recipesAPI.isEmpty {
                    print("\(self.recipesAPI[0].title)")
                } else {
                    print("No recipes with \(ingredients)")
                }
                
            } else {
                print("Failed to fetch recipes. HTTP Response: \(response)")
            }
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
    
    
    func addRecipeItem(id: Int, name: String, recipe_id: Int, image: String) async {
        let url = URL(string: "\(baseURL)/recipes")!
        let recipeItem = Recipe(id: id, name: name, recipe_id: recipe_id, image: image)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(recipeItem)
        

        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            print("Data: \(data)")
            let jsonDataResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200 || httpResponse.statusCode == 201){
                    recipes.append(jsonDataResponse.recipe)
                }else{
                }
            }
        } catch {
            print("Error with users/login call: \(error)")
            loginError = " We couldn't log you in. Please double-check your email and password."
        }
    }
    
    func fetchShoppingList() async {
            let url = URL(string: "\(baseURL)/notes")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            do {
                let (data, response) = try await session.data(for: request)
                
                let decodedResponse = try JSONDecoder().decode(ShoppingNotesResponse.self, from: data)
                shoppinglist = decodedResponse.shoppingnote

                
                for _ in shoppinglist {
    //                print("ShoppingNote ID: \(item.id), Name: \(item.note)")
                }
                
                print("HTTP Response: \(response)")
                
            } catch {
                print("Error fetching pantry/notes: \(error)")
            }
        }
        func addShoppingNote(note: String) async {
            guard !note.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    
            let url = URL(string: "\(baseURL)/notes")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
            let newNote = ShoppingNoteRequest(note: note)
            request.httpBody = try? JSONEncoder().encode(newNote)
                    
            let session = URLSession(configuration: .default)
            do {
                let (data, _) = try await session.data(for: request)
                if let jsonString = String(data: data, encoding: .utf8) {
                        print("Server Response: \(jsonString)")
                    }
    //            let addedNote = try JSONDecoder().decode(ShoppingNote.self, from: data)
                let addedNote = ShoppingNote(id: (shoppinglist.last?.id ?? 0) + 1, note: newNote.note)

                DispatchQueue.main.async {
                    self.shoppinglist.append(addedNote)
                        }
                print("Added note: \(addedNote.note)")
            } catch {
                print("Error adding note: \(error)")
                    }
                }
            
        func deleteShoppingNote(id: Int) async {
            let url = URL(string: "\(baseURL)/notes/\(id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let session = URLSession(configuration: .default)
            do {
                let (_, response) = try await session.data(for: request)
                DispatchQueue.main.async {
                    self.shoppinglist.removeAll { $0.id == id }
                }
                print("Deleted note with ID: \(id), Response: \(response)")
            } catch {
                print("Error deleting note: \(error)")
            }
        }

    
}
