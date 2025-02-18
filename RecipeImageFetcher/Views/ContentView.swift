//
//  ContentView.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import SwiftUI
import MessageUI

struct ContentView: View, Sendable {
    @EnvironmentObject var fetcher: RecipeCollectionFetcher
    
    @State private var memeText = ""
    @State private var textSize = 12.0
    @State private var textColor = Color.blue
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                LoadableImage(imageMetadata: fetcher.currentRecipe)
                
                TextField(
                    "Meme Text",
                    text: $memeText,
                    prompt: Text("Enter search text here...")
                )
                .focused($isFocused)
                .font(.system(size: textSize))
                .shadow(radius: 10)
                .foregroundColor(textColor)
                .padding()
                .multilineTextAlignment(.trailing)
                                

                
                if !memeText.isEmpty {
                    VStack {
                        HStack {
                            Text("Font Size")
                                .fontWeight(.semibold)
                            Slider(value: $textSize, in: 20...140)
                        }
                        
                        HStack {
                            Text("Font Color")
                                .fontWeight(.semibold)
                            ColorPicker("Font Color", selection: $textColor)
                                .labelsHidden()
                                .frame(width: 124, height: 23, alignment: .leading)
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: 325)
                    
                }
                
                HStack {
                    Button {
                        Task {
                            try! await fetcher.fetchData(searchTerm: memeText)
                            if let randomImage = fetcher.imageData!.results.randomElement() {
                                fetcher.currentRecipe = randomImage
                            }
                        }
                        
                    } label: {
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.largeTitle)
                                .padding(.bottom, 4)
                            Text("Shuffle Photo")
                        }
                        .frame(maxWidth: 180, maxHeight: .infinity)
                    }.disabled(memeText.isEmpty)
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    Button {
                        isFocused = true
                    } label: {
                        VStack {
                            Image(systemName: "textformat")
                                .font(.largeTitle)
                                .padding(.bottom, 4)
                            Text("Add Text")
                        }
                        .frame(maxWidth: 180, maxHeight: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxHeight: 180, alignment: .center)
            }
            .padding()
            .environmentObject(fetcher)
            .navigationTitle("Image Fetcher")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RecipeCollectionFetcher())
}
