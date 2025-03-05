//
//  RecipeCollectionFetcher.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import Foundation
import OSLog
import Combine

@Observable class RecipeCollectionFetcher {
    var imageData: RecipeCollection?
    var currentRecipe = defaultRecipe
    
    private var searchString: String = ""
    let key = UserDefaults.standard.value(forKey: "SpoonacularKey") ?? ""
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.RecipeImageFetcher", category: "RecipeCollectionFetcher")
    
    enum FetchError: Error {
        case badRequest
        case badJSON
    }
    
    func fetchData(searchTerm: String, cuisine: String, number: Int, showInfo: Bool) async
    throws   {
        if key as! String == "" {
            logger.log("key is empty, cannot fetch data")
            return
        }
        searchString = searchTerm.replacingOccurrences(of: " ", with: ",+")
        
        if searchString.isEmpty {
            logger.log( "searchString is empty , cannot fetch data")
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.spoonacular.com"
        urlComponents.path = "/recipes/complexSearch"
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "query", value: searchString))
        queryItems.append(URLQueryItem(name: "number", value: number.description))
        queryItems.append(URLQueryItem(name: "cuisine", value: cuisine))
        queryItems.append(URLQueryItem(name: "addRecipeInformation", value: showInfo ? "true" : "false"))
        urlComponents.queryItems = queryItems
        urlComponents.query! += "\(key)"
        guard let url = urlComponents.url else {
            logger.log( "could not create url , cannot fetch data")
            return
        }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
        logger.log( "data fetched is : \(data.debugDescription)")
        
        Task { @MainActor in
            imageData = try JSONDecoder().decode(RecipeCollection.self, from: data)
            if imageData == nil {
                logger.log( "imageData is nil")
            } else {
                logger.log( "imageData is not nil")
                logger.log( "The number of recipes fetched is : \(self.imageData!.results.count)")
                if imageData!.results.count > 0 {
                    currentRecipe = imageData!.results[0]
                    logger.log("currentRecipe set to first fetched recipe")
                } else {
                    currentRecipe = defaultRecipe
                    logger.log("No recipes found, currentRecipe set to default recipe")
                }
            }
        }
    }
}
