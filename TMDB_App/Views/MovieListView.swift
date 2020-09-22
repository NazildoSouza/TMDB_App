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
    @State private var selectId = 0 {
        didSet {
            if selectId == 0 {
                selectMovie()
            } else {
                selectTV()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                if !showSearch {
                    if !nowPlayingState.isLoading && !upcomingState.isLoading && !topRatedState.isLoading && !popularState.isLoading {
                        ScrollView(showsIndicators: false) {
                            Spacer().frame(height: 135)
                            
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
                    
                    VStack(alignment: .center) {
                        Text("Tmdb App")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        
                        HStack{
                            
                            Button(action: {
                                
                                self.selectId = 0
                                
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
                                
                                self.selectId = 1
                                
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
                        .background(Color.black.opacity(0.25))
                        .clipShape(Rectangle())
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        .padding([.horizontal, .vertical])
                        
                    }
                    .frame(width: geo.size.width)
                    .background(BlurView(style: .systemMaterial).clipShape(Corners(corner: [.bottomLeft, .bottomRight], size: CGSize(width: 20, height: 20))).edgesIgnoringSafeArea([.top, .horizontal]).shadow(radius: 3))
                    
                }
                
                if showSearch {
                    
                    SearchView()
                    
                }
                
                Button(action: {
                    showSearch.toggle()
                }, label: {
                    Image(systemName: showSearch ? "xmark" : "magnifyingglass")
                        .imageScale(.large)
                })
                .padding(.all, 8)
                .padding(.trailing, 30)
                .padding(.top, 10)
                
                if nowPlayingState.movies == nil && upcomingState.movies == nil && topRatedState.movies == nil && popularState.movies == nil {
                    //shimer
                }
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
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
