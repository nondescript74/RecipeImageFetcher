//
//  Recipe.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import SwiftUI

let defaultRecipe = Recipe(id: 122478, title: "Chicken 65", image: "https://img.spoonacular.com/recipes/1224783-312x231.jpg", imageType: "jpg")
let secondRecipe = Recipe(id: 637876, title: "Chicken 652", image: "https://img.spoonacular.com/recipes/637876-312x231.jpg", imageType: "jpg")
let thirdRecipe = Recipe(id: 42569, title: "Chicken BBQ", image: "https://img.spoonacular.com/recipes/42569-312x231.jpg", imageType: "jpg")
let fourthRecipe = Recipe(id: 1654723, title: "Chicken Fry", image: "https://img.spoonacular.com/recipes/1654723-312x231.png", imageType: "jpg")

struct Recipe: Codable, Hashable {
    var id: Int
    var title: String
    var image: String
    var imageType: String
}

struct RecipeCollection: Codable {
    var offset: Int
    var number: Int
    var results: [Recipe]
    var totalResults: Int
}
