//
//  MovieListState.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 12/08/20.
//

import SwiftUI

class MovieListState: ObservableObject {
    
    @Published var movies: [Movie]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    
    private let movieService: MovieService

    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }    
    
    func loadMovies(with endpoint: MovieListEndPoint, mediaType: MediaType) {
        self.movies = nil
        self.isLoading = true
        self.movieService.fetchMovies(from: endpoint, mediaType: mediaType) { [weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let response):
                self.movies = response.results
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
    
}
