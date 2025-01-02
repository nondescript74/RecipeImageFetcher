//
//  RecipeImageFetcherApp.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import SwiftUI

@main
struct RecipeImageFetcherApp: App {
    @StateObject private var fetcher = RecipeCollectionFetcher()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(fetcher)
            }
        }
    }
}
