//
//  RecipeCollectionFetcher.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import Foundation

class RecipeCollectionFetcher: ObservableObject {
    @Published var imageData: RecipeCollection?
    @Published var currentRecipe = defaultRecipe
    
    private var searchString: String = ""
    let key = UserDefaults.standard.value(forKey: "SpoonacularKey") ?? ""
    
//    var urlString = "https://api.spoonacular.com/recipes/complexSearch?query=chicken&number=4"
    
    enum FetchError: Error {
        case badRequest
        case badJSON
    }
    
    func fetchData(searchTerm: String, cuisine: String, number: Int, showInfo: Bool) async
    throws   {
        if key as! String == "" {
            print("key is empty")
            return
        }
        searchString = searchTerm.replacingOccurrences(of: " ", with: ",+")
        
        if searchString.isEmpty {
            print("searchString is empty")
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
            print("could not create url")
            return
        }
        print("url being sent is: ", url.absoluteString)
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
        print("data fetched is : ", data.debugDescription)
        
        Task { @MainActor in
            imageData = try JSONDecoder().decode(RecipeCollection.self, from: data)
            if imageData == nil {
                print("imageData is nil")
            } else {
                print("imageData is not nil")
                print("The number of recipes fetched is : \(imageData!.results.count)")
                if imageData!.results.count > 0 {
                    currentRecipe = imageData!.results[0]
                } else {
                    currentRecipe = defaultRecipe
                }
            }
        }
    }
}
