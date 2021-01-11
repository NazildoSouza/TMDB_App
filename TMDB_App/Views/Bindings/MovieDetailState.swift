//
//  MovieDetailState.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 16/08/20.
//

import SwiftUI

class MovieDetailState: ObservableObject {
    
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var error: NSError?
    @Published var idPerson: Int = 0
    
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func loadMovie(id: Int, mediaType: MediaType) {
        self.movie = nil
        self.isLoading = true
        self.movieService.fetchMovie(id: id, mediaType: mediaType) { [weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
}
