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
    
    let urlString = "https://api.spoonacular.com/recipes/complexSearch?query=chicken&number=4&apiKey="
    
    enum FetchError: Error {
        case badRequest
        case badJSON
    }
    
    func fetchData() async
    throws  {
        guard let url = URL(string: urlString) else { return }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
        
        Task { @MainActor in
            imageData = try JSONDecoder().decode(RecipeCollection.self, from: data)
            print("The number of recipes fetched is : \(imageData!.results.count)")
        }
    }
    
}
