//
//  SearchList.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 03/10/20.
//

import SwiftUI

struct SearchList: View {
    var mediaType: String
    var movies: [Movie]
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 15) {
            Text(mediaType)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
             //   .padding(.leading)
            
            ForEach(self.movies, id: \.self) { movie in
                NavigationLink(destination: MovieDetailView(movieId: movie.id, media: movie.mediaType!, personLink: .navigation)) {
                    
                    SearchListCard(movie: movie)
                    
                }
                .buttonStyle(PlainButtonStyle())
                
            }
        }
    }
}

//struct SearchList_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchList()
//    }
//}
