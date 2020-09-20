//
//  MovieService.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 10/08/20.
//

import Foundation

protocol MovieService {
    
    func fetchMovies(from endpoint: MovieListEndPoint, mediaType: MediaType, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    func fetchMovie(id: Int, mediaType: MediaType, completion: @escaping (Result<Movie, MovieError>) -> ())
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
}

enum MovieListEndPoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    case onTheAir = "on_the_air"
    case airingToday = "airing_today"
    
    var description: String {
        switch self {
        case .nowPlaying: return "Nos Cinemas"
        case .upcoming: return "Próximos"
        case .topRated: return "Mais Votados"
        case .popular: return "Populares"
        case .onTheAir: return "Na TV"
        case .airingToday: return "Em Exibição Hoje"
        }
    }
}

enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Falha ao buscar Dados"
        case .invalidEndpoint: return "Endpoint Inválido"
        case .invalidResponse: return "Resposta Inválida"
        case .noData: return "Sem Dados"
        case .serializationError: return "Falhou ao decodificar Dados"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}
