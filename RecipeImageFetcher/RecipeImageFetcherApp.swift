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
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "circle.fill")
                        Text("Display")
                    }
                ApiKeyEntry()
                    .tabItem {
                        Image(systemName: "key")
                        Text("API Key")
                    }
            }
            .environmentObject(fetcher)
        }
    }
}
