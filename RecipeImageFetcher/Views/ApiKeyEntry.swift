//
//  ApiKeyEntry.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import SwiftUI
import OSLog

struct ApiKeyEntry: View {
    @State fileprivate var apiKey: String = ""
    let skey = "SpoonacularKey"
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.headydiscy.RecipeImageFetcher", category: "ApiKeyEntry")
    
    private enum msgs: String {
        case key = "Please enter your api key"
        case ksave = "Save Api Key"
        case kx = "key: "
        case kno = "No Key"
    }
    
    @MainActor
    fileprivate func setApiKey(key: String) {
        if apiKey.isEmpty ||  apiKey == UserDefaults.standard.string(forKey: skey) {
            apiKey = ""
            logger.log("No Key is set")
            return
        }
        DispatchQueue.main.async {
            UserDefaults.standard.set(apiKey, forKey: skey)
            apiKey = ""
            logger.log("apiKey was set \(apiKey, privacy: .private)")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(msgs.kx.rawValue +  (UserDefaults.standard.string(forKey: skey) ?? msgs.kno.rawValue))
                
                HStack {
                    Button(action: {
                        // What to perform
                        setApiKey(key: apiKey)
                        logger.info("User set apiKey")
                    }) {
                        // How the button looks like
                        Rectangle()
                            .foregroundColor(Color.blue)
                            .frame(width: 35, height: 35)
                            .cornerRadius(5)
                    }
                    .disabled(apiKey.isEmpty).padding(.bottom)
                    .buttonBorderShape(.capsule)
                    
                    TextField(msgs.key.rawValue, text: $apiKey)
                        .border(Color.black, width: 1)
                }
            }
            Spacer()
            .navigationTitle(Text(msgs.ksave.rawValue))
        }
    }
}

#Preview {
    ApiKeyEntry()
}
