//
//  Recipe.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import SwiftUI
import Foundation

let defaultRecipe = Bundle.main.decode(Recipe.self, from: "defaultRecipe.json")
// Recipe(id: 715538, title: "What to make for dinner tonight?? Bruschetta Style Pork & Pasta", image: "https://img.spoonacular.com/recipes/715538-312x231.jpg", imageType: "jpg")

struct Result: Codable, Hashable {
    var id: Int
    var title: String
    var image: String
    var imageType: String
}

struct Recipe: Codable, Hashable {
    
    var id: Int
    var image: String
    var imageType, title: String
    var readyInMinutes, servings: Int
    var sourceUrl: String
    var vegetarian, vegan, glutenFree, dairyFree: Bool
    var veryHealthy, cheap, veryPopular, sustainable: Bool
    var lowFodmap: Bool
    var weightWatcherSmartPoints: Int
    var gaps: String
    var preparationMinutes, cookingMinutes, aggregateLikes, healthScore: Int
    var creditsText: String
    var license: String?
    var sourceName: String
    var pricePerServing: Double
    var summary: String
    var cuisines, dishTypes, diets, occasions: [String]
    var spoonacularScore: Double
    
    enum CodingKeys: String, CodingKey {
        case id, image, imageType, title, readyInMinutes, servings
        case sourceUrl
        case vegetarian, vegan, glutenFree, dairyFree, veryHealthy, cheap, veryPopular, sustainable, lowFodmap, weightWatcherSmartPoints, gaps, preparationMinutes, cookingMinutes, aggregateLikes, healthScore, creditsText, license, sourceName, pricePerServing, summary, cuisines, dishTypes, diets, occasions, spoonacularScore
    }
}

struct RecipeCollection: Codable {
    var offset: Int
    var number: Int
    var results: [Recipe]
    var totalResults: Int
}

struct Cuisine: Codable, Hashable, Equatable {
    var name: String
    
    static func == (lhs: Cuisine, rhs: Cuisine) -> Bool {
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}

