//
//  MoviePosterCard.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 11/08/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MoviePosterCard: View {
    
    let movie: Movie
    
    var body: some View {

        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            AnimatedImage(url: self.movie.posterURL)
                .resizable()
                .placeholder {
                    ZStack {
                        Rectangle().foregroundColor(Color(.systemGray4))
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 90)
                        .foregroundColor(.secondary)
                    }
                }
                .indicator(SDWebImageActivityIndicator.medium)
                .frame(width: 200, height: 300)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .shadow(radius: 4)
            
            ZStack {
                Circle()
                    .frame(width: 52, height: 52)
                    .foregroundColor(Color(.black).opacity(0.9))
                
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color(.systemGray2).opacity(0.7), lineWidth: 4)
                    .frame(width: 45, height: 45)
                
                Circle()
                    .trim(from: 0, to: CGFloat((movie.voteAverage ?? 0) / 10))
                    .stroke(movie.voteAverage ?? 0 > 7 ? Color.green : (movie.voteAverage ?? 0 < 2 ? Color.red : Color.yellow), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 45, height: 45)
                    .rotationEffect(.init(degrees: -90))

                HStack(spacing: 0) {
                    Text(String(getPercent(current: CGFloat(movie.voteAverage ?? 0))))
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    Text("%")
                        .font(.system(size: 8))
                        .foregroundColor(Color.white)
                        .offset(y: -2)
                }
                
            }
            .padding(.trailing, 10)
            .offset(y: 10)
        }
    }
    
    func getPercent(current : CGFloat) -> String {
        
        let per = current * 10
        
        return String(format: "%.0f", per)
    }
}

struct MoviePosterCard_Previews: PreviewProvider {
    static var previews: some View {
        MoviePosterCard(movie: Movie.stubbedMovie)
    }
}
