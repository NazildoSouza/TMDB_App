//
//  MovieDataView.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 10/12/20.
//

import SwiftUI

class MovieDataView: ObservableObject {
    
    @Published var mediaType: MediaType = .person
    
    @Published var selectId = 0 {
        didSet {
            showSearch = false
            showDetail = false
            showPerson = false
            
        }
    }
    
    @Published var showDetail = false
    @Published var showPerson = false
    @Published var showSearch = false {
        didSet {
            showDetail = false
        }
    }
    
    @Published var idMovie = 100
    @Published var idPerson = 100
    
    @Published var scrollIdMovie: String?
    @Published var scrollIdSerie: String?
    @Published var scrollIdSearch: String?
    
    let color: [Color] = [.blue, .gray, .green, .orange, .pink, .purple, .white, .red, .yellow, .black].shuffled()
    
}
