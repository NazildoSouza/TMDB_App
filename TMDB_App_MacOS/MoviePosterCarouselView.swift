//
//  MoviePosterCarouselView.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 09/12/20.
//

import SwiftUI

struct MoviePosterCarouselView: View {
    
    @Binding var movies: [Movie]?
    @EnvironmentObject var data: MovieDataView
    
    let title: String
    let media: MediaType
    
    let layout = [
        GridItem(.adaptive(minimum: 200, maximum: 250))
    ]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            if movies != nil {
                
                LazyVGrid(columns: layout, spacing: 35) {
                    
                    ForEach(self.movies!.indices) { index in
                        
                        MoviePosterRow(movie: movies![index], onHover: movies![index].onHover ?? false)
                            .padding(.horizontal, 10)
                            .onHover { (hovering) in
                                movies?[index].onHover = hovering
                            }
                            .onTapGesture {
                                if media == .movie {
                                    data.scrollIdMovie = title + String(movies![index].id)
                                } else if media == .tv {
                                    data.scrollIdSerie = title + String(movies![index].id)
                                }
                                data.mediaType = media
                                data.idMovie = movies![index].id
                                data.showDetail.toggle()
                            }
                            .id(title + String(movies![index].id))
                            .help((self.movies![index].title ?? self.movies![index].name) ?? "Desconhecido")
                            .animation(nil)
                        
                    }
                }
                .padding(.bottom)
                
            }
        }
    }
    
}

//struct MoviePosterCarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoviePosterCarouselView(title: "Now", movies: Movie.stubbedMovies, media: .movie)
//    }
//}
