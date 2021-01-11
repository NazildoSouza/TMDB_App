//
//  ContentView.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 09/12/20.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        MovieListView()
            .frame(minWidth: NSScreen.main!.visibleFrame.midX + 300, maxWidth: .infinity, minHeight: NSScreen.main!.visibleFrame.midY + 150, maxHeight: .infinity, alignment: .center)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
