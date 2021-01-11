//
//  SearchList.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 11/12/20.
//

import SwiftUI

struct SearchList: View {
    
    @EnvironmentObject var data: MovieDataView
    
    var mediaType: String
    var movies: [Movie]
    @State private var onHovering = [Bool]()
    
    let layout = [
        GridItem(.adaptive(minimum: 150, maximum: 250))
    ]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            Text(mediaType)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            if onHovering.count > 0 && movies.count > 0 {
                
                LazyVGrid(columns: layout, spacing: 35) {
                    ForEach(self.movies.indices) { index in
                        
                        SearchListCard(movie: movies[index], onHover: onHovering[index])
                            .onHover { (hovering) in
                                onHovering[index] = hovering
                            }
                            .onTapGesture {
                                data.scrollIdSearch = mediaType + String(movies[index].id)
                                data.idMovie = movies[index].id
                                data.mediaType = movies[index].mediaType ?? .movie
                                data.showDetail = true
                            }
                            .id(mediaType + String(movies[index].id))
                            .help(self.movies[index].title ?? self.movies[index].name ?? "Desconhecido")
                        
                    }
                }
            }
            
            Divider()
            
        }
        .padding(.horizontal, 40)
        .onAppear {
            if movies.count > 0 {
                for _ in 0..<movies.count {
                    onHovering.append(false)
                }
            }
        }
    }
}
