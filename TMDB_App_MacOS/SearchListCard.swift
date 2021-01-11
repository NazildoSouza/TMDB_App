//
//  SearchListCard.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 11/12/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchListCard: View {
    
    @EnvironmentObject var data: MovieDataView
    var movie: Movie
    var onHover: Bool
    
    @State private var number = Int.random(in: 0..<10)
    
    var body: some View {
        
        VStack(spacing: 10) {
            ZStack {
                WebImage(url: movie.mediaType == .person ? movie.profileURL : movie.posterURL)
                    .resizable()
                    .placeholder {
                        ZStack {
                            Rectangle().foregroundColor(data.color[number].opacity(0.5))
                            
                            if (movie.mediaType == .person ? movie.profilePath : movie.posterPath) == nil {
                                Image(systemName: movie.mediaType == .person ? "person.fill" : "photo")
                                    .resizable()
                                    .frame(width: movie.mediaType == .person ? 45 : 60, height: 50)
                                    .foregroundColor(.secondary)
                            } else {
                                ProgressView()
                            }
                        }
                    }
                    .scaleEffect(onHover ? 1.008 : 1)
                    .aspectRatio(9/14, contentMode: .fit)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 2, y: 3)
                    
                
                Color.black.opacity(onHover ? 0.2 : 0)
                    .aspectRatio(9/14, contentMode: .fit)
                    .cornerRadius(8)
                
            }
            
            
            VStack(alignment: .center, spacing: 5) {
                Text(movie.title ?? movie.name ?? "Desconhecido")
                    .fontWeight(.bold)
                    .padding(.top, 5)
                    .lineLimit(1)
                    .help(movie.title ?? movie.name ?? "Desconhecido")
                
                Text(movie.yearText != "-" ? movie.yearText : (movie.yearTextSerie != "-" ? movie.yearTextSerie : movie.knownForDepartment ?? "-"))
                    .foregroundColor(.secondary)
                
            }
            
        }
        .padding()
    }
}
