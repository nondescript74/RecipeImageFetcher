//
//  ContentView.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import Foundation
import SwiftUI
import MessageUI
import os

struct ContentView: View, Sendable {
    @EnvironmentObject var fetcher: RecipeCollectionFetcher
    
    @State private var memeText = ""
    @State private var textSize = 12.0
    @State private var textColor = Color.blue
    @State private var xectionName: String = "Indian"
    @State private var numberOfRecipes: Int = 4
    @State private var showRecipeInfo: String = "No Info"
    
    fileprivate func getBookSectionNames() -> [String] {
        let namesOfCuisines = Bundle.main.decode([Cuisine].self, from: "cuisines.json").sorted(by: {$0.name < $1.name})
        var names: [String] = []
        namesOfCuisines.forEach {names.append($0.name)}
        return names
    }
    
    fileprivate func getChoices() -> [String] {
        return ["No Info", "Info"]
    }
    
    fileprivate let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.RecipeImageFetcher", category: "ContentView")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    if fetcher.imageData != nil {
                        Text("Total Results: \(fetcher.imageData!.totalResults)")
                        ForEach(fetcher.imageData!.results, id: \.self) { imgdata in
                            LoadableImage(imageMetadata: imgdata)
                                .frame(width: 312, height: 231)
                            Text(imgdata.title)
                        } .padding()
                    } else {
                        LoadableImage(imageMetadata: fetcher.currentRecipe)
                            .frame(width: 312, height: 231)
                        Text(fetcher.currentRecipe.title)
                    }
                    
                    TextField(
                        "Meme Text",
                        text: $memeText,
                        prompt: Text("Enter search text here...")
                    )
                    .font(.system(size: textSize))
                    .shadow(radius: 10)
                    .foregroundColor(textColor)
                    .padding()
                    .multilineTextAlignment(.center)
                    
                    HStack {
                        Picker("Select", selection: $xectionName) {
                            ForEach(getBookSectionNames(), id: \.self) { bookSection in
                                Text(bookSection).fontWeight(.light)
                            }
                        }.padding(.leading)
                        Spacer()
                        Picker("Number", selection: $numberOfRecipes) {
                            ForEach(0..<16) { index in
                                Text(index.description)
                                    .fontWeight(.light)
                            }
                        }.padding(.trailing)
                        Spacer()
                        
                        Picker("Information", selection: $showRecipeInfo) {
                            ForEach(getChoices(), id: \.self) { text in
                                Text(text)
                                    .fontWeight(.light)
                            }
                        }.padding(.trailing)
                        
                        
                    }
                    
                    HStack {
                        Button {
                            Task {
                                try! await fetcher.fetchData(searchTerm: memeText, cuisine: xectionName, number: numberOfRecipes, showInfo: showRecipeInfo == "No Info" ? false : true)
                                
                                memeText = ""
                            }
                            
                        } label: {
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.largeTitle)
                                    .padding(.bottom, 4)
                                Text("Get Recipe")
                            }
                            .frame(maxWidth: 150, maxHeight: 100)
                        }.disabled(memeText.isEmpty)
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxHeight: 180, alignment: .center)
                }
            }
            
            .environmentObject(fetcher)
            .navigationTitle("Image Fetcher")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RecipeCollectionFetcher())
}


private var decoder: JSONDecoder = JSONDecoder()
private var encoder: JSONEncoder = JSONEncoder()

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return decoded
    }
}
