//
//  ApiKeyEntry.swift
//  RecipeImageFetcher
//
//  Created by Zahirudeen Premji on 1/2/25.
//

import SwiftUI

struct ApiKeyEntry: View {
    @State fileprivate var apiKey: String = ""
    let skey = "SpoonacularKey"
    
    private enum msgs: String {
        case kv = "ApiKeyEntry: "
        case kvset = "apiKey set "
        case key = "Please enter your api key"
        case ksave = "Save Api Key"
        case kx = "key: "
        case kno = "No Key"
        case kdidnot = "did not set key"
    }
    
    @MainActor
    fileprivate func setApiKey(key: String) {
        if apiKey.isEmpty ||  apiKey == UserDefaults.standard.string(forKey: skey) {
            apiKey = ""
#if DEBUG
            print(msgs.kv.rawValue + msgs.kdidnot.rawValue)
#endif
            return
        }
        DispatchQueue.main.async {
            UserDefaults.standard.set(apiKey, forKey: skey)
            apiKey = ""
#if DEBUG
            print(msgs.kv.rawValue + msgs.kvset.rawValue + UserDefaults.standard.string(forKey: skey)!)
#endif
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
