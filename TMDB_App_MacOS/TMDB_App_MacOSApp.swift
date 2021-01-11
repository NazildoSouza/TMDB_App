//
//  TMDB_App_MacOSApp.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 09/12/20.
//

import SwiftUI

@main
struct TMDB_App_MacOSApp: App {
    @StateObject private var movieDataView = MovieDataView()
    
    init() {
        NSScrollView.swizzleScrollWhell()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(movieDataView)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
