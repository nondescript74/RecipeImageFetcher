//
//  LoadableImage.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import SwiftUI

struct LoadableImage: View {
    var imageMetadata: Recipe
    
    var body: some View {
        AsyncImage(url: URL(string: imageMetadata.image)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .accessibility(hidden: false)
                    .accessibilityLabel(Text(imageMetadata.title))
            }  else if phase.error != nil  {
                VStack {
                    Image("Rae-312x231")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                    Text("The recipes were all busy.")
                        .font(.title2)
                    Text("Please try again.")
                        .font(.title3)
                }
                
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    LoadableImage(imageMetadata: defaultRecipe)
}
