//
//  MovieListView.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 09/12/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieListView: View {
    @StateObject private var nowPlayingState = MovieListState()
    @StateObject private var upcomingState = MovieListState()
    @StateObject private var topRatedState = MovieListState()
    @StateObject private var popularState = MovieListState()
    @StateObject private var movieSearchState = MovieSearchState()
    
    @EnvironmentObject var movieDataView: MovieDataView
    @Environment(\.colorScheme) var colorScheme
    
    @State private var mediaType: MediaType = .movie
    @State private var showSearch = false
    @State private var textPicker = ["Filmes", "Séries"]
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(spacing: 0) {
                
                ZStack {
                    HStack {
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                
                                movieDataView.showDetail = false
                            }
                        }, label: {
                            Image(systemName: "chevron.backward")
                        })
                        .disabled(!movieDataView.showDetail)
                        .padding(.leading, 90)
                        
                        Spacer()
                        
                        SearchBar(query: self.$movieSearchState.query, showSearch: $movieDataView.showSearch)
                            .onChange(of: movieDataView.showSearch) { (search) in
                                if search == false {
                                    movieSearchState.query = ""
                                }
                            }
                            .onChange(of: movieSearchState.query) { (query) in
                                if query != "" {
                                    movieDataView.showSearch = true
                                    
                                } else {
                                    withAnimation(.spring()) {
                                        movieDataView.showSearch = false
                                    }
                                }
                                movieDataView.scrollIdSearch = nil
                            }
                            .padding(.trailing, 10)
                        
                    }
                    
                    HStack {
                        Spacer()
                        
                        Picker("Select", selection: $movieDataView.selectId) {
                            ForEach(0..<self.textPicker.count, id: \.self) {
                                Text(textPicker[$0])
                                    .tag($0)
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .labelsHidden()
                        .frame(width: 250)
                        .help("Selecione Filmes ou Séries")
                        .onChange(of: self.movieDataView.selectId) { (id) in
                            if id == 0 {
                                selectMovie()
                                movieDataView.showSearch = false
                                movieDataView.showDetail = false
                                movieDataView.showPerson = false
                                movieSearchState.query = ""
                            } else {
                                selectTV()
                                movieDataView.showSearch = false
                                movieDataView.showDetail = false
                                movieDataView.showPerson = false
                                movieSearchState.query = ""
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 10)
                .background(Color(colorScheme == .light ? .clear : .windowBackgroundColor))
                .background(BlurWindow(blendMode: .withinWindow))
                .zIndex(1.0)
                
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    if !movieDataView.showDetail && !movieDataView.showSearch {
                        
                        ZStack {
                            
                            if nowPlayingState.movies != nil && upcomingState.movies != nil && topRatedState.movies != nil && popularState.movies != nil {
                                
                                ScrollView {
                                    
                                    ScrollViewReader { value in
                                        
                                        Group {
                                            
                                            if nowPlayingState.movies != nil {
                                                MoviePosterCarouselView(movies: $nowPlayingState.movies, title: mediaType == .movie ? "Em Cartaz" : "Em Exibição Hoje", media: mediaType)
                                                
                                            } else {
                                                LoadingView(isLoading: self.nowPlayingState.isLoading, error: self.nowPlayingState.error) {
                                                    self.nowPlayingState.loadMovies(with: mediaType == .movie ? .nowPlaying : .airingToday, mediaType: mediaType)
                                                }
                                            }
                                            
                                            Divider()
                                            
                                            
                                            if upcomingState.movies != nil {
                                                MoviePosterCarouselView(movies: $upcomingState.movies, title: mediaType == .movie ? "Próximas Estreias" : "Na TV", media: mediaType)
                                                
                                            } else {
                                                LoadingView(isLoading: self.upcomingState.isLoading, error: self.upcomingState.error) {
                                                    self.upcomingState.loadMovies(with: mediaType == .movie ? .upcoming : .onTheAir, mediaType: mediaType)
                                                }
                                            }
                                            
                                            Divider()
                                            
                                            if topRatedState.movies != nil {
                                                MoviePosterCarouselView(movies: $topRatedState.movies, title: "Mais Bem Avaliados", media: mediaType)
                                                
                                            } else {
                                                LoadingView(isLoading: self.topRatedState.isLoading, error: self.topRatedState.error) {
                                                    self.topRatedState.loadMovies(with: .topRated, mediaType: mediaType)
                                                }
                                            }
                                            
                                            Divider()
                                            
                                            if popularState.movies != nil {
                                                MoviePosterCarouselView(movies: $popularState.movies, title: "Populares", media: mediaType)
                                                
                                            } else {
                                                LoadingView(isLoading: self.popularState.isLoading, error: self.popularState.error) {
                                                    self.popularState.loadMovies(with: .popular, mediaType: mediaType)
                                                }
                                            }
                                            
                                        }
                                        .padding(.horizontal, 40)
                                        .onAppear {
                                            if mediaType == .movie && movieDataView.scrollIdMovie != nil {
                                                value.scrollTo(movieDataView.scrollIdMovie, anchor: .center)
                                            } else if mediaType == .tv && movieDataView.scrollIdSerie != nil {
                                                value.scrollTo(movieDataView.scrollIdSerie, anchor: .center)
                                            }
                                        }
                                    }
                                    
                                }
                                .transition(.fade(duration: 1))
                                
                            } else {
                                
                                ProgressView("Aguarde")
                                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                                    .animation(.default)
                                
                            }
                            
                        }
                        //    .opacity((!movieDataView.showDetail && !movieDataView.showSearch) ? 1 : 0)
                    }
                    
                    if movieDataView.showSearch && !movieDataView.showDetail {
                        
                        SearchView(movieSearchState: movieSearchState, geometryProxy: geo)
                        // .opacity((movieDataView.showSearch && !movieDataView.showDetail) ? 1 : 0)
                    }
                    
                    if movieDataView.showDetail {
                        
                        MovieDetailView(movieId: movieDataView.idMovie, media: movieDataView.mediaType, geometryProxy: geo)
                        
                    }
                    
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all, edges: .all)
            .background(Color(colorScheme == .light ? .controlBackgroundColor : .clear))
            
        }
        .onAppear {
            selectMovie()
        }
//        .toolbar {
//            ToolbarItem {
//                
//            }
//        }
        
    }
    
    func selectTV() {
        
        self.mediaType = .tv
        
        self.nowPlayingState.loadMovies(with: .airingToday, mediaType: mediaType)
        self.upcomingState.loadMovies(with: .onTheAir, mediaType: mediaType)
        self.topRatedState.loadMovies(with: .topRated, mediaType: mediaType)
        self.popularState.loadMovies(with: .popular, mediaType: mediaType)
        
    }
    
    func selectMovie() {
        
        self.mediaType = .movie
        
        self.nowPlayingState.loadMovies(with: .nowPlaying, mediaType: mediaType)
        self.upcomingState.loadMovies(with: .upcoming, mediaType: mediaType)
        self.topRatedState.loadMovies(with: .topRated, mediaType: mediaType)
        self.popularState.loadMovies(with: .popular, mediaType: mediaType)
        
    }
}

struct MovieListView_Previews: PreviewProvider {
    
    static var previews: some View {
        MovieListView()
    }
}
