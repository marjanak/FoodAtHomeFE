//
//  DetailRecipeModel.swift
//  FoodAtHomeFE
//
//  Created by New Student on 2/7/25.
//

import Foundation

struct DetailRecipeResponse: Codable {
    let recipes : RecipeData
}

struct RecipeData : Codable {
    let extendedIngredients : [ExtendedIngredient]
    let id : Int
    let image : String
    let instructions : [String]
    let readyInMinutes : Int
    let title : String
}
struct ExtendedIngredientResponse: Codable, Hashable {
    let original: String
}
