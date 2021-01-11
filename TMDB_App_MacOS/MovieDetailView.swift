//
//  MovieDetailView.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 09/12/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailView: View {
    
    @StateObject private var movieDetailState = MovieDetailState()
    @EnvironmentObject var data: MovieDataView
    
    var movieId: Int
    var media: MediaType
    var geometryProxy: GeometryProxy
    
    var body: some View {
        
        ZStack {
//            ZStack {
//                HStack {
//
//                    Button(action: {
//                        withAnimation(.spring()) {
//
//                          //  movieDataView.showDetail = false
//                        }
//                    }, label: {
//                        Image(systemName: "chevron.backward")
//                    })
//                  //  .disabled(!movieDataView.showDetail)
//
//                   Spacer()
//
//                }
//            }
//            .padding(.vertical, 8)
//         //   .background(Color(colorScheme == .light ? .clear : .windowBackgroundColor))
//            .background(BlurWindow(blendMode: .withinWindow))
            
            
            if movieDetailState.movie != nil {
                ScrollView {
                    
                    if media == .person {
                        MovieDetailPersonView(movie: self.movieDetailState.movie!)
                        
                    } else {
                        MovieDetailListView(movie: self.$movieDetailState.movie, geometryProxy: geometryProxy)
                    }
                }
                .transition(.fade(duration: 1))
                
            } else {
                LoadingView(isLoading: movieDetailState.isLoading, error: movieDetailState.error) {
                    self.movieDetailState.loadMovie(id: self.movieId, mediaType: MediaType(rawValue: media.rawValue)!)
                }
                .frame(width: geometryProxy.size.width, height: geometryProxy.size.height, alignment: .center)
                .animation(nil)
            }
            
        }
        .onAppear {
            self.movieDetailState.loadMovie(id: self.movieId, mediaType: MediaType(rawValue: media.rawValue)!)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct MovieDetailListView: View {
    
    @EnvironmentObject var dataMovie: MovieDataView
    @StateObject private var selectedPerson = MovieDetailState()
    @State private var onHover: [Bool] = []
    @State private var number = Int.random(in: 0..<10)
    
    @Binding var movie: Movie!
    var geometryProxy: GeometryProxy
    
    var body: some View {
            
        VStack {
            
            WebImage(url: movie.backdropURL)
                .resizable()
                .placeholder(content: {
                    ZStack {
                        Rectangle().foregroundColor(dataMovie.color[number].opacity(0.5))
                        
                        if movie.backdropPath == nil {
                            Image(systemName: "photo")
                                .font(.system(size: 350))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                })
                .aspectRatio(16/9, contentMode: .fill)
            
            Text(movie.title ?? movie.name ?? "Desconhecido")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.all)
            
            HStack {
                Text(movie.yearText != "-" ? movie.yearText : (movie.yearTextSerie != "-" ? movie.yearTextSerie : "-"))
                Text("・")
                Text(movie.genreText)
                Text("・")
                Text(movie.durationText != "-" ? movie.durationText : (movie.durationTextSerie != "-" ? movie.durationTextSerie : "-"))
            }
            .font(.title3)
            .padding(.all)
            
            Text(movie.overview ?? "")
                .font(.title3)
                .frame(maxWidth: 800)
                .layoutPriority(1)
                .help(movie.overview ?? "")
                .padding(.all)
            
            if (movie.budget ?? 0 > 0) || (movie.revenue ?? 0 > 0) {
                HStack(spacing: 30) {
                    VStack {
                        Text("Orçamento:")
                        Text(movie.budgetText)
                    }
                    Text("・")
                    VStack {
                        Text("Receita:")
                        Text(movie.revenueText)
                    }
                }
                .font(.title3)
                .padding(.all)
            }
            
            Divider()
            
            HStack(spacing: 12) {
                Spacer()
                
                ZStack {
                    Circle()
                        .frame(width: 62, height: 62)
                        .foregroundColor(Color.black)
                    
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color(.gray).opacity(0.7), lineWidth: 4)
                        .frame(width: 55, height: 55)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat((movie.voteAverage ?? 0) / 10))
                        .stroke(movie.voteAverage ?? 0 > 7 ? Color.green : (movie.voteAverage ?? 0 < 2 ? Color.red : Color.yellow), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 55, height: 55)
                        .rotationEffect(.init(degrees: -90))
                    
                    HStack(spacing: 0) {
                        Text(String(getPercent(current: CGFloat(movie.voteAverage ?? 0))))
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Text("%")
                            .font(.system(size: 10))
                            .foregroundColor(Color.white)
                            .offset(y: -2)
                    }
                    
                }
                
                Text("Avaliação dos Usuários")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(.all)
            .padding(.leading, 40)
            
            VStack(alignment: .leading, spacing: 10) {
                Divider()
                
                if movie.cast != nil && movie.cast!.count > 0 {
                    Text("Elenco Principal")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.all)
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .center, spacing: 25) {
                            ForEach(movie.cast!.indices) { index in
                                    
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    WebImage(url: movie.cast![index].posterURL)
                                        .resizable()
                                        .placeholder {
                                            ZStack {
                                                Rectangle().foregroundColor(dataMovie.color[number].opacity(0.5))

                                                if movie.cast![index].profilePath == nil {
                                                    Image(systemName: "person.fill")
                                                        .resizable()
                                                        .frame(width: 60, height: 60)
                                                        .foregroundColor(.secondary)
                                                } else {
                                                    ProgressView()
                                                }
                                            }
                                        }
                                        .aspectRatio(9/14, contentMode: .fill)
                                    
                                    Text(movie.cast![index].name)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: 150)
                                        .lineLimit(1)
                                        .padding([.top, .horizontal])
                                        .layoutPriority(1)
                                        .help(movie.cast![index].name)
                                    Text(movie.cast![index].character)
                                        .frame(maxWidth: 150)
                                        .lineLimit(1)
                                        .padding([.bottom, .horizontal])
                                        .layoutPriority(1)
                                        .help(movie.cast![index].character)
                                    
                                    Spacer(minLength: 25)
                                    
                                }
                                .frame(width: 150, height: 270)
                                .background(Color(.windowBackgroundColor))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: Color.black.opacity(0.4), radius: 4, x: 2, y: 4)
                                .padding(.vertical)
                                .onTapGesture {
                                    selectedPerson.loadMovie(id: movie.cast![index].id, mediaType: .person)
                                    dataMovie.showPerson.toggle()
                                }
                                
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    
                }
                
                if movie.crew != nil && movie.crew!.count > 0 {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        if movie.directors != nil && movie.directors!.count > 0 {
                            Divider()
                            
                            Text("Diretor(a)")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.all)
                            
                            ScrollView(.horizontal) {
                                HStack(alignment: .top, spacing: 25) {
                                    ForEach(self.movie.directors!.indices) { index in
                                        
                                        VStack {
                                            
                                            WebImage(url: movie.directors![index].posterURL)
                                                .resizable()
                                                .placeholder {
                                                    ZStack {
                                                        Rectangle().foregroundColor(dataMovie.color[number].opacity(0.5))
                                                        
                                                        if movie.directors![index].profilePath == nil {
                                                            Image(systemName: "person.fill")
                                                                .resizable()
                                                                .frame(width: 60, height: 60)
                                                                .foregroundColor(.secondary)
                                                        } else {
                                                            ProgressView()
                                                        }
                                                    }
                                                }
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .clipShape(Circle())
                                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
                                            
                                            Text(movie.directors![index].name)
                                                .fontWeight(.bold)
                                            
                                        }
                                        .onTapGesture {
                                            selectedPerson.loadMovie(id: movie.directors![index].id, mediaType: .person)
                                            dataMovie.showPerson.toggle()
                                        }
                                    }
                                }
                                .padding(.horizontal, 35)
                                .padding(.vertical)
                            }
                        }
                        
                        if movie.producers != nil && movie.producers!.count > 0 {
                            Divider()
                            
                            Text("Produção")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.all)
                            
                            ScrollView(.horizontal) {
                                HStack(alignment: .top, spacing: 25) {
                                    ForEach(self.movie.producers!.indices) { index in
                                        
                                        VStack {
                                            
                                            
                                            WebImage(url: movie.producers![index].posterURL)
                                                .resizable()
                                                .placeholder {
                                                    ZStack {
                                                        Rectangle().foregroundColor(dataMovie.color[number].opacity(0.5))
                                                        
                                                        if movie.producers![index].profilePath == nil {
                                                            Image(systemName: "person.fill")
                                                                .resizable()
                                                                .frame(width: 60, height: 60)
                                                                .foregroundColor(.secondary)
                                                        } else {
                                                            ProgressView()
                                                        }
                                                    }
                                                }
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .clipShape(Circle())
                                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
                                            
                                            Text(movie.producers![index].name)
                                                .fontWeight(.bold)
                                            
                                        }
                                        .onTapGesture {
                                            selectedPerson.loadMovie(id: movie.producers![index].id, mediaType: .person)
                                            dataMovie.showPerson.toggle()
                                        }
                                    }
                                }
                                .padding(.horizontal, 35)
                                .padding(.vertical)
                            }
                        }
                        
                        if movie.screenWriters != nil && movie.screenWriters!.count > 0 {
                            Divider()
                            
                            Text("Roteirização")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.all)
                            
                            ScrollView(.horizontal) {
                                HStack(alignment: .top, spacing: 25) {
                                    ForEach(self.movie.screenWriters!) { crew in
                                        
                                        VStack {
                                            
                                            WebImage(url: crew.posterURL)
                                                .resizable()
                                                .placeholder {
                                                    ZStack {
                                                        Rectangle().foregroundColor(dataMovie.color[number].opacity(0.5))
                                                        
                                                        if crew.profilePath == nil {
                                                            Image(systemName: "person.fill")
                                                                .resizable()
                                                                .frame(width: 60, height: 60)
                                                                .foregroundColor(.secondary)
                                                        } else {
                                                            ProgressView()
                                                        }
                                                    }
                                                }
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 150, height: 150)
                                                .clipShape(Circle())
                                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 4)
                                            
                                            Text(crew.name)
                                                .fontWeight(.bold)
                                            
                                        }
                                        .onTapGesture {
                                            selectedPerson.loadMovie(id: crew.id, mediaType: .person)
                                            dataMovie.showPerson.toggle()
                                        }
                                    }
                                }
                                .padding(.horizontal, 35)
                                .padding(.vertical)
                            }
                        }
                    }
                }
                
                if movie.youtubeTrailers != nil && movie.youtubeTrailers!.count > 0 {
                    Divider()
                    
                    Text("Trailers")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.all)
                    
                    ForEach(movie.youtubeTrailers!.indices) { index in
                        
                        Link(destination: movie.youtubeTrailers![index].youtubeURL!, label: {
                            HStack {
                                Text(movie.youtubeTrailers![index].name)
                                    .font(.title2)
                                    .underline(movie.youtubeTrailers![index].onHover ?? false, color: Color(.systemBlue))
                            }
                        })
                        .padding(.horizontal, 35)
                        .onHover { (hovering) in
                            movie.videos?.results[index].onHover = hovering
                        }
                        
                    }
                    .padding(.vertical, 6)
                    .padding([.bottom, .horizontal])
                    
                }
            
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $dataMovie.showPerson) {
            VStack(spacing: 0) {
                Button(action: {
                    self.dataMovie.showPerson = false
                }) {
                    Text("Fechar")
                        .font(.title3)
                }
                .foregroundColor(Color(NSColor.systemBlue))
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical)
                
                Divider()
                
                Spacer(minLength: 0)
                
                if selectedPerson.movie != nil {
                    MovieDetailPersonView(movie: selectedPerson.movie!)
                } else {
                    LoadingView(isLoading: selectedPerson.isLoading, error: selectedPerson.error) {
                        print("teste")
                    }
                }
                
                Spacer(minLength: 0)
            }
            .frame(minWidth: NSScreen.main?.visibleFrame.midX, idealWidth: NSScreen.main?.visibleFrame.midX, maxWidth: geometryProxy.size.width - 50, minHeight: NSScreen.main?.visibleFrame.midY, idealHeight: NSScreen.main?.visibleFrame.midY, maxHeight: geometryProxy.size.height - 50, alignment: .center)
            .background(BlurWindow(blendMode: .behindWindow))
        }
        
    }
    
    func getPercent(current : CGFloat) -> String {
        
        let per = current * 10
        
        return String(format: "%.0f", per)
    }
}
