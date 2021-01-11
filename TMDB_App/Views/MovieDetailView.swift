//
//  MovieDetailView.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 16/08/20.
//

import SwiftUI
import SDWebImageSwiftUI
//import WebKit

struct MovieDetailView: View {
    
    @StateObject private var movieDetailState = MovieDetailState()
    var movieId: Int
    var media: MediaType
    var personLink: PersonLink
    
    var body: some View {
        ZStack {
            
            LoadingView(isLoading: movieDetailState.isLoading, error: movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movieId, mediaType: MediaType(rawValue: media.rawValue)!)
            }
            
            if movieDetailState.movie != nil {
                if media == .person {
                    MovieDetailPersonView(personLink: self.personLink, movie: self.movieDetailState.movie!)
                    
                } else {
                    MovieDetailListView(movieDetailState: self.movieDetailState, movie: self.movieDetailState.movie!)
                }
            }
        }
        .onAppear {
            self.movieDetailState.loadMovie(id: self.movieId, mediaType: MediaType(rawValue: media.rawValue)!)
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieId: Movie.stubbedMovies[0].id, media: .movie, personLink: .navigation)
    }
}

struct MovieDetailListView: View {
    
    @ObservedObject var movieDetailState: MovieDetailState
    @State private var selectedTrailer: MovieVideo?
    @State private var showPerson = false
    let movie: Movie
    @State var imageOffset: CGFloat = 450
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                AnimatedImage(url: movie.backdropURL)
                    .resizable()
                    .overlay(LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemBackground).opacity(0.9), Color.clear, Color(.systemBackground).opacity(0.5), Color(.systemBackground)]), startPoint: .top, endPoint: .bottom))
                    .edgesIgnoringSafeArea(.all)
                
                ZStack(alignment: .top) {
                    if g.size.width < 500 {
                        AnimatedImage(url: movie.backdropURL)
                            .resizable()
                            .placeholder {
                                ZStack(alignment: .center) {
                                    Rectangle().foregroundColor(Color(.systemGray4))
                                        .frame(height: 400)

                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 130, height: 100)
                                        .foregroundColor(.secondary)
                                        .offset(y: -50)
                                }
                            }
                            .indicator(SDWebImageActivityIndicator.medium)
                            .aspectRatio(16/9, contentMode: .fit)
                            .clipShape(Corners(corner: [.bottomLeft, .bottomRight], size: CGSize(width: 18, height: 18)))
                            .shadow(radius: 5)
                            .edgesIgnoringSafeArea(.top)
                            .zIndex(1)

                    }
                    
                    ScrollView(showsIndicators: false) {
                        if g.size.width > 500 {
                            GeometryReader { geo in
                                AnimatedImage(url: movie.backdropURL)
                                    .resizable()
                                    .placeholder {
                                        ZStack(alignment: .center) {
                                            Rectangle().foregroundColor(Color(.systemGray4))
                                              //  .frame(height: 400)
                                            
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width: 260, height: 200)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .indicator(SDWebImageActivityIndicator.medium)
                                    // .aspectRatio(16/9, contentMode: .fit)
                                    .clipShape(Corners(corner: [.bottomLeft, .bottomRight], size: CGSize(width: 18, height: 18)))
                                    .offset(y: geo.frame(in: .global).minY > 0 ? -geo.frame(in: .global).minY : 0)
                                    .frame(height: geo.frame(in: .global).minY > 0 ? UIScreen.main.bounds.height + geo.frame(in: .global).minY  : UIScreen.main.bounds.height)
                                    .shadow(radius: 5)
                            }
                            .frame(height: UIScreen.main.bounds.height)
                        } else {
                            Spacer().frame(height: 160)
                        }
                        
                        Text(movie.title ?? movie.name ?? "Desconhecido")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.all)
                        
                        HStack {
                            Text(movie.genreText)
                            Text("・")
                            Text(movie.yearText != "-" ? movie.yearText : (movie.yearTextSerie != "-" ? movie.yearTextSerie : "-"))
                            Text("・")
                            Text(movie.durationText != "-" ? movie.durationText : (movie.durationTextSerie != "-" ? movie.durationTextSerie : "-"))
                        }
                        .padding(.horizontal, g.size.width > 500 ? 45 : 25)
                        
                        Text(movie.overview ?? "")
                            .padding(.all)
                            .padding(.horizontal, g.size.width > 500 ? 45 : 0)
                        
                        Divider()
                        
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .frame(width: 62, height: 62)
                                    .foregroundColor(Color(.black).opacity(0.9))
                                
                                Circle()
                                    .trim(from: 0, to: 1)
                                    .stroke(Color(.systemGray2).opacity(0.7), lineWidth: 4)
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
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        .padding(.all)
                        .padding(.leading, 40)
                        .padding(.leading, g.size.width > 500 ? 60 : 0)
                        
                        Divider()
                    
                        VStack(alignment: .leading, spacing: 10) {
                            if movie.cast != nil && movie.cast!.count > 0 {
                                Text("Elenco Principal").font(.headline)
                                    .padding(.all)
                                    .padding(.leading, g.size.width > 500 ? 60 : 0)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .top, spacing: 15) {
                                        ForEach(self.movie.cast!.prefix(10)) { cast in
                                            Button {
                                                self.movieDetailState.idPerson = cast.id
                                                self.showPerson = true
                                                
                                            } label: {
                                                VStack(alignment: .leading, spacing: 5) {
                                                    ZStack {
                                                        Rectangle().foregroundColor(Color(.systemGray4))
                                                        
                                                        Image(systemName: "person.fill")
                                                            .resizable()
                                                            .frame(width: 60, height: 60)
                                                            .foregroundColor(.secondary)
                                                        
                                                        AnimatedImage(url: cast.posterURL)
                                                            .resizable()
                                                        
                                                    }
                                                    .frame(width: 150, height: 210)
                                                    
                                                    Text(cast.name)
                                                        .fontWeight(.bold)
                                                        .lineLimit(1)
                                                        .padding([.top, .horizontal])
                                                    Text(cast.character)
                                                        .font(.subheadline)
                                                        .lineLimit(1)
                                                        .padding([.bottom, .horizontal])
                                                }
                                                .frame(maxWidth: 150)
                                                .background(BlurView(style: .systemMaterial))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                                .shadow(radius: 5)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .frame(height: 310)
                                    .padding(.horizontal, 25)
                                    
                                }
                                
                            }
                            
                            if movie.crew != nil && movie.crew!.count > 0 {
                                VStack(alignment: .leading, spacing: 5) {
                                    if movie.directors != nil && movie.directors!.count > 0 {
                                        Text("Diretor(a)").font(.headline)
                                        ForEach(self.movie.directors!.prefix(2)) { crew in
                                            Button {
                                                self.movieDetailState.idPerson = crew.id
                                                self.showPerson = true
                                                
                                            } label: {
                                                HStack {
                                                    Text(crew.name)
                                                    Spacer()
                                                    ZStack {
                                                        Rectangle().foregroundColor(Color(.systemGray4))
                                                        Image(systemName: "person.fill")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(.secondary)
                                                        
                                                        AnimatedImage(url: crew.posterURL)
                                                            .resizable()
                                                            .scaledToFill()
                                                        
                                                    }
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 3)
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    
                                    if movie.producers != nil && movie.producers!.count > 0 {
                                        Text("Produção").font(.headline)
                                            .padding(.top)
                                        ForEach(self.movie.producers!.prefix(2)) { crew in
                                            Button {
                                                self.movieDetailState.idPerson = crew.id
                                                self.showPerson = true
                                                
                                            } label: {
                                                HStack {
                                                    Text(crew.name)
                                                    Spacer()
                                                    ZStack {
                                                        Rectangle().foregroundColor(Color(.systemGray4))
                                                        Image(systemName: "person.fill")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(.secondary)
                                                        
                                                        AnimatedImage(url: crew.posterURL)
                                                            .resizable()
                                                            .scaledToFill()
                                                        
                                                    }
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 3)
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    
                                    if movie.screenWriters != nil && movie.screenWriters!.count > 0 {
                                        Text("Roteirização").font(.headline)
                                            .padding(.top)
                                        ForEach(self.movie.screenWriters!.prefix(2)) { crew in
                                            Button {
                                                self.movieDetailState.idPerson = crew.id
                                                self.showPerson = true
                                                
                                            } label: {
                                                HStack {
                                                    Text(crew.name)
                                                    Spacer()
                                                    ZStack {
                                                        Rectangle().foregroundColor(Color(.systemGray4))
                                                        Image(systemName: "person.fill")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(.secondary)
                                                        
                                                        AnimatedImage(url: crew.posterURL)
                                                            .resizable()
                                                            .scaledToFill()
                                                        
                                                    }
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(Circle())
                                                    .shadow(radius: 3)
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.all)
                                .padding(.horizontal)
                                .padding(.horizontal, g.size.width > 500 ? 45 : 0)
                            }
                        }
                        .sheet(isPresented: $showPerson) {
                            MovieDetailView(movieId: self.movieDetailState.idPerson, media: .person, personLink: .sheet)
                        }
                        
                        if movie.youtubeTrailers != nil && movie.youtubeTrailers!.count > 0 {
                            Divider()
                            
                            Text("Trailers").font(.headline)
                                .padding(.all)
                            
                            ForEach(movie.youtubeTrailers!) { trailer in
                                Button(action: {
                                    self.selectedTrailer = trailer
                                }) {
                                    HStack {
                                        Text(trailer.name)
                                        Spacer()
                                        Image(systemName: "play.circle.fill")
                                            .foregroundColor(Color(UIColor.systemBlue))
                                    }
                                }
                                //                        Link(destination: trailer.youtubeURL!) {
                                //                            HStack {
                                //                                Text(trailer.name)
                                //                                Spacer()
                                //                                Image(systemName: "play.circle.fill")
                                //                                    .foregroundColor(Color(UIColor.systemBlue))
                                //                            }
                                //                        }
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.vertical, 10)
                            .padding([.bottom, .horizontal])
                            .padding(.horizontal, g.size.width > 500 ? 45 : 0)
                            .fullScreenCover(item: self.$selectedTrailer) { trailer in
                                SafariView(url: trailer.youtubeURL!).edgesIgnoringSafeArea(.all)
                            }
                            
                        }
                        
                        Spacer()
                            .frame(height: 30)
                        
                    }
                    
                }
                .background(BlurView(style: .systemMaterial).ignoresSafeArea())
                
            }
            .ignoresSafeArea(.all, edges: [.bottom, .horizontal])
            
        }
        
    }
    
    func getPercent(current : CGFloat) -> String {
        
        let per = current * 10
        
        return String(format: "%.0f", per)
    }
}

struct MovieDetailPersonView: View {
    
    @Environment(\.presentationMode) var dismiss
    let personLink: PersonLink
    let movie: Movie
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    if geo.size.width > 500 {
                        ScrollView {
                            VStack {
                                
                                Text(movie.title ?? movie.name ?? "Desconhecido")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .frame(width: UIScreen.main.bounds.width / 1.5 - 50)
                                    .padding(.top)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        ZStack {
                                            Rectangle().foregroundColor(Color(.systemGray4))
                                            
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .frame(width: 90, height: 100)
                                                .foregroundColor(.secondary)
                                            
                                            AnimatedImage(url: movie.profileURL)
                                                .resizable()
                                                .indicator(SDWebImageActivityIndicator.medium)
                                            
                                        }
                                        .frame(width: 160, height: 230)
                                        .clipShape(Corners(corner: [.bottomLeft, .bottomRight, .topLeft, .topRight], size: CGSize(width: 18, height: 18)))
                                        .shadow(radius: 10)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 15) {
                                        Text(movie.knownForDepartment ?? "")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        Text(movie.placeOfBirth ?? "")
                                        Text(movie.birthday ?? "")
                                    }
                                    .padding(.horizontal)
                                    
                                    Spacer(minLength: 0)
                                }
                                .padding(.leading, 40)
                                
                            }
                            
                            Divider()
                            
                            Text(movie.biography ?? "")
                                .padding(.all)
                                .padding(.horizontal, 30)
                            
                            Spacer()
                                .frame(height: 30)
                            
                        }
                        .background(BlurView(style: .systemMaterial))
                    } else {
                        VStack {
                            
                            Text(movie.title ?? movie.name ?? "Desconhecido")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .frame(width: UIScreen.main.bounds.width / 1.5 - 50)
                                .padding(.top, personLink == .sheet ? 20 : 50)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    ZStack {
                                        Rectangle().foregroundColor(Color(.systemGray4))
                                        
                                        Image(systemName: "person.fill")
                                            .resizable()
                                            .frame(width: 90, height: 100)
                                            .foregroundColor(.secondary)
                                        
                                        AnimatedImage(url: movie.profileURL)
                                            .resizable()
                                            .indicator(SDWebImageActivityIndicator.medium)
                                        
                                    }
                                    .frame(width: 160, height: 230)
                                    .clipShape(Corners(corner: [.bottomLeft, .bottomRight, .topLeft, .topRight], size: CGSize(width: 18, height: 18)))
                                    .shadow(radius: 10)
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text(movie.knownForDepartment ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(movie.placeOfBirth ?? "")
                                    Text(movie.birthday ?? "")
                                }
                                .padding(.horizontal)
                                
                                Spacer(minLength: 0)
                            }
                            
                            Divider()
                            
                            ScrollView {
                                
                                Text(movie.biography ?? "")
                                    .padding(.all)
                                
                                Spacer()
                                    .frame(height: 30)
                                
                            }
                            
                        }
                        .background(BlurView(style: .systemMaterial))
                        
                    }
                    
                    Button {
                        dismiss.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(.all, 10)
                            .background(BlurView(style: .systemMaterialDark))
                            .clipShape(Circle())
                            .padding([.top, .leading])
                            .shadow(radius: 6)
                            .opacity(personLink == .sheet ? 1 : 0)
                    }
                    
                }
                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}
