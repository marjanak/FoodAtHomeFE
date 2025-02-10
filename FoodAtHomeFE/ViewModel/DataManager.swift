//
//  DataManager.swift
//  Food_At_Home
//
//  Created by hi on 1/25/25.
//

import SwiftUI


@MainActor @Observable
class DataManager {
    let baseURL = URL(string: "https://food-at-home-api.onrender.com")!
    var signedIn: Bool = false
    var registered: Bool = false
    var pantry: [Ingredient] = []
    var recipes: [Recipe] = []
    var loginError: String = ""
    var errorMsg: String = ""
    var recipesAPI: [RecipeAPI] = []
    var shoppinglist : [ShoppingNote] = []
    var showAlertRecipeForm: Bool = false
    var recipedata : RecipeData?
    
    func signInWith(username: String, password: String) async {
        let url = URL(string: "\(baseURL)/users/login")!
        let loginRequest = LoginRequest(username: username, password: password)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(loginRequest)
        
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            let jsonDataResponse = try JSONDecoder().decode(Response.self, from: data)
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
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(loginRequest)
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            print("Data: \(data)")
            let jsonDataResponse = try JSONDecoder().decode(Response.self, from: data)
            print("Message: \(jsonDataResponse.message)")
            print("Response: \(response)")
            if jsonDataResponse.message.localizedCaseInsensitiveContains("created") {
                registered = true
                loginError = ""
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
    
    func logout() async {
        let url = URL(string: "\(baseURL)/users/logout")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        signedIn = false
        print(signedIn)
        
        do {
            let (data, _) = try await session.data(for: request)
            let jsonResponse = try JSONDecoder().decode(Response.self, from: data)
            
            if jsonResponse.message.localizedCaseInsensitiveContains("logged out") {
                signedIn = false
                errorMsg = ""
                loginError = ""
            }
        } catch {
            loginError = "Logout failed. Please try again."
        }
    }
    
    func fetchPantry() async {
        let url = URL(string: "\(baseURL)/ingredients")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        do {
            let (data, _) = try await session.data(for: request)
            let decodedResponse = try JSONDecoder().decode(IngredientsResponse.self, from: data)
            pantry = decodedResponse.ingredients
            
        } catch {
            print("Error fetching pantry/ingredients: \(error)")
        }
    }
    
    func updateExpirationDate(ingredientID: Int, expirationDate: String) async {
        let url = URL(string: "\(baseURL)/useringredients/\(ingredientID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(UserIngredient(expiration_date: expirationDate))
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(for: request)
            let _ = try JSONDecoder().decode(Response.self, from: data)
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    print("updated")
                }
            }
        } catch {
            print("Error with users/login call: \(error)")
            loginError = " We couldn't log you in. Please double-check your email and password."
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
            let _ = try JSONDecoder().decode(Response.self, from: data)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                pantry.removeAll() {$0.id == ingredientID}
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
            let (data, _) = try await session.data(for: request)
            let decodedResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
            recipes = decodedResponse.recipe
            recipes = recipes.sorted { $0.favorite && !$1.favorite }

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
            let _ = try JSONDecoder().decode(Response.self, from: data)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                recipes.removeAll() {$0.id == recipeID}
            }
        } catch {
            print("Error deleting recipe: \(error)")
        }
    }
    
    func updateFavorite(recipeID: Int) async {
        guard let url = URL(string: "\(baseURL)/recipes/\(recipeID)") else {
                print("Invalid URL for recipe ID \(recipeID)")
                return
            }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
  
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let updatedRecipe = try JSONDecoder().decode(Recipe.self, from: data)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let index = recipes.firstIndex(where: { $0.id == recipeID }) {
                    recipes[index] = updatedRecipe
                }
            }
            } catch {
            print("Error updating favorite: \(error)")
        }
    }
    
    func addPantryItem(pantryItem: String, expirationDate: Date?) async {
        guard let url = URL(string: "\(baseURL)/ingredients") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let expirationDateString = expirationDate != nil ? formatter.string(from: expirationDate!) : nil
        
        let ingredientRequest = IngredientRequest(ingredient: pantryItem, expirationDate: expirationDateString)
        
        do {
            request.httpBody = try JSONEncoder().encode(ingredientRequest)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response type")
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                let decodedResponse = try JSONDecoder().decode(AddIngredientsResponse.self, from: data)
                print("Success: \(decodedResponse.message)")
            } else {
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                print("Server Error: \(errorResponse.message)")
            }
        } catch {
            print("Error adding ingredient: \(error)")
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
                    showAlertRecipeForm = true
                    errorMsg = "No recipes with \(ingredients)"
                }
            }
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
    
    
    func addRecipeItem(name: String, recipe_id: Int, image: String) async {
        let url = URL(string: "\(baseURL)/recipes")!
        let recipeItem = Recipe(id: 0, name: name, recipe_id: recipe_id, image: image, favorite: false)
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
            print(error)
        }
    }
    
    func fetchShoppingList() async {
            let url = URL(string: "\(baseURL)/notes")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            do {
                let (data, _) = try await session.data(for: request)
                let decodedResponse = try JSONDecoder().decode(ShoppingNotesResponse.self, from: data)
                shoppinglist = decodedResponse.shoppingnote
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
    func fetchdetailrecipe(id: Int) async {
            let url = URL(string: "\(baseURL)/recipes/\(id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let session = URLSession(configuration: .default)
            do {
                let (data, _) = try await session.data(for: request)
                
                if let jsonString = String(data: data, encoding: .utf8) {
                        print("Full API Response: \(jsonString)")
                    }
                
                let decodedResponse = try JSONDecoder().decode(DetailRecipeResponse.self, from: data)
                recipedata = decodedResponse.recipes
                
                print("Decoded Ingredients: \(recipedata?.extendedIngredients.count ?? 0) items")
                } catch {
                    print("Error fetching recipedata/recipes: \(error)")
                }
                
//                print("HTTP Response: \(response)")
//                
//            } catch {
//                print("Error fetching recipedata/recipes: \(error)")
//            }
//            
        }
    
}
