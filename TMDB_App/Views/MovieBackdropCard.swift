//
//  MovieBackDropCard.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 11/08/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieBackdropCard: View {
    
    let movie: Movie
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            VStack(alignment: .leading) {
                
                AnimatedImage(url: self.movie.backdropURL)
                    .resizable()
                    .placeholder {
                        ZStack {
                            Rectangle().foregroundColor(Color(.systemGray4))
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 100, height: 80)
                                .foregroundColor(.secondary)
                        }
                    }
                    .indicator(SDWebImageActivityIndicator.medium)
                    .aspectRatio(16/9, contentMode: .fit)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                
                Text(movie.title ?? movie.name ?? "Desconhecido")
                    .padding([.top, .leading], 10)
                    .lineLimit(1)
                
            }
            
            ZStack {
                Circle()
                    .frame(width: 47, height: 47)
                    .foregroundColor(Color(.black).opacity(0.9))
                
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color(.systemGray2).opacity(0.7), lineWidth: 4)
                    .frame(width: 40, height: 40)
                
                Circle()
                    .trim(from: 0, to: CGFloat((movie.voteAverage ?? 0) / 10))
                    .stroke(movie.voteAverage ?? 0 > 7 ? Color.green : (movie.voteAverage ?? 0 < 2 ? Color.red : Color.yellow), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.init(degrees: -90))
                
                HStack(spacing: 0) {
                    Text(String(getPercent(current: CGFloat(movie.voteAverage ?? 0))))
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    Text("%")
                        .font(.system(size: 6))
                        .foregroundColor(Color.white)
                        .offset(y: -2)
                }
                
            }
            .padding(.trailing, 10)
            .offset(y: -28)
            
        }
    }
    
    func getPercent(current : CGFloat) -> String {
        
        let per = current * 10
        
        return String(format: "%.0f", per)
    }
}

struct MovieBackdropCard_Previews: PreviewProvider {
    static var previews: some View {
        MovieBackdropCard(movie: Movie.stubbedMovie)
    }
}
