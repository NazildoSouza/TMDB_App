//
//  MovieListView.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 12/08/20.
//

import SwiftUI

struct MovieListView: View {
    
    @StateObject private var nowPlayingState = MovieListState()
    @StateObject private var upcomingState = MovieListState()
    @StateObject private var topRatedState = MovieListState()
    @StateObject private var popularState = MovieListState()
    
    @State private var mediaType: MediaType = .movie
    @State private var showSearch = false
    @State private var textPicker = ["Filmes", "Séries"]
    @State private var selectId = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                if !showSearch {
                    if !nowPlayingState.isLoading && !upcomingState.isLoading && !topRatedState.isLoading && !popularState.isLoading {
                        ScrollView(showsIndicators: false) {
                            Spacer().frame(height: 90)
                            
                            Group {
                                if nowPlayingState.movies != nil {
                                    MoviePosterCarouselView(title: mediaType == .movie ? "Em Cartaz" : "Em Exibição Hoje", movies: nowPlayingState.movies!, media: mediaType)
                                    
                                } else {
                                    LoadingView(isLoading: self.nowPlayingState.isLoading, error: self.nowPlayingState.error) {
                                        self.nowPlayingState.loadMovies(with: mediaType == .movie ? .nowPlaying : .airingToday, mediaType: mediaType)
                                    }
                                }
                            }
                            
                            Group {
                                if upcomingState.movies != nil {
                                    MovieBackdropCarouselView(title: mediaType == .movie ? "Próximas Estreias" : "Na TV", movies: upcomingState.movies!, media: mediaType)
                                } else {
                                    LoadingView(isLoading: self.upcomingState.isLoading, error: self.upcomingState.error) {
                                        self.upcomingState.loadMovies(with: mediaType == .movie ? .upcoming : .onTheAir, mediaType: mediaType)
                                    }
                                }
                            }
                            
                            Group {
                                if topRatedState.movies != nil {
                                    MovieBackdropCarouselView(title: "Mais Bem Avaliados", movies: topRatedState.movies!, media: mediaType)
                                } else {
                                    LoadingView(isLoading: self.topRatedState.isLoading, error: self.topRatedState.error) {
                                        self.topRatedState.loadMovies(with: .topRated, mediaType: mediaType)
                                    }
                                }
                            }
                            
                            Group {
                                if popularState.movies != nil {
                                    MovieBackdropCarouselView(title: "Populares", movies: popularState.movies!, media: mediaType)
                                } else {
                                    LoadingView(isLoading: self.popularState.isLoading, error: self.popularState.error) {
                                        self.popularState.loadMovies(with: .popular, mediaType: mediaType)
                                    }
                                }
                            }
                            
                        }
                        .edgesIgnoringSafeArea(.horizontal)
                    } else {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView("Aguarde")
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
           
                GeometryReader { geo in
                    Picker("Select", selection: $selectId) {
                        ForEach(0..<self.textPicker.count, id: \.self) {
                            Text(textPicker[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    /*
                        HStack{
                            
                            Button(action: {
                                if self.selectId != 0 {
                                    self.selectId = 0
                                }
                            }) {
                                
                                Text("Filmes")
                                    .foregroundColor(self.selectId == 0 ? .black : .white)
                                    .padding(.vertical, 5)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - (geo.size.width > 500 ? 100 : 30))
                            }
                            .background(self.selectId == 0 ? Color.white : Color.clear)
                            .clipShape(Rectangle())
                            .cornerRadius(8)
                            
                            
                            Button(action: {
                                if self.selectId != 1 {
                                    self.selectId = 1
                                }
                            }) {
                                
                                Text("Séries")
                                    .foregroundColor(self.selectId == 1 ? .black : .white)
                                    .padding(.vertical, 5)
                                    .frame(width: (UIScreen.main.bounds.width / 2) - (geo.size.width > 500 ? 100 : 30))
                            }
                            .background(self.selectId == 1 ? Color.white : Color.clear)
                            .clipShape(Rectangle())
                            .cornerRadius(8)
                            
                        }
                      */
                    //    .background(Color.black.opacity(0.25))
                    //    .clipShape(Rectangle())
                   //     .cornerRadius(8)
                   //     .shadow(radius: 1)
                        .padding([.horizontal, .bottom])
                        .padding(.top, 10)
                        .frame(width: geo.size.width)
                        .background(BlurView(style: .systemMaterial).clipShape(Corners(corner: [.bottomLeft, .bottomRight], size: CGSize(width: 20, height: 20))).edgesIgnoringSafeArea([.top, .horizontal]).shadow(radius: 3))
                    .onChange(of: self.selectId) { (id) in
                        if id == 0 {
                            selectMovie()
                        } else {
                            selectTV()
                        }
                    }
                    
                }
             
                if showSearch {
                    
                    SearchView()
                    
                }
                
                if nowPlayingState.movies == nil && upcomingState.movies == nil && topRatedState.movies == nil && popularState.movies == nil {
                    //shimer
                }
                
            }
            .navigationBarTitle(showSearch ? "Busca" : "Tmdb", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showSearch.toggle()
            }, label: {
                Image(systemName: showSearch ? "xmark" : "magnifyingglass")
                    .imageScale(.large)
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            selectMovie()
        }
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

struct SelectMediaView: View {
    @Binding var selected: String
    //    let names = ["Filmes", "Séries"]
    var title: String
    var animation: Namespace.ID
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        Button {
            withAnimation(.spring()) {
                selected = title
            }
            
        } label: {
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 35)
                
                if selected == title {
                    
                    Rectangle()
                        .fill(colorScheme == .light ? Color.white : Color.gray)
                        .frame(height: 33)
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        .matchedGeometryEffect(id: "Tab", in: animation)
                }
                
                Text(title)
                    .foregroundColor(Color.primary)
                    .fontWeight(.bold)
            }
        }
        
    }
}
