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
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    if fetcher.imageData != nil {
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
                        Button {
                            Task {
                                try! await fetcher.fetchData(searchTerm: memeText)
                                if let randomImage = fetcher.imageData!.results.randomElement() {
                                    fetcher.currentRecipe = randomImage
                                }
                                memeText = ""
                            }
                            
                        } label: {
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.largeTitle)
                                    .padding(.bottom, 4)
                                Text("Get Recipe")
                            }
                            .frame(maxWidth: 180, maxHeight: .infinity)
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
