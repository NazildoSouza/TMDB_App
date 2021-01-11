//
//  TMDB_AppApp.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 10/08/20.
//

import SwiftUI

@main
struct TMDB_AppApp: App {
    init() {

        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        
        standardAppearance.titleTextAttributes = attrs

        UINavigationBar.appearance().standardAppearance = standardAppearance
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
