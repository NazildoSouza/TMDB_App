//
//  MoviePosterRow.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 09/12/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MoviePosterRow: View {
    
    @EnvironmentObject var data: MovieDataView
    let movie: Movie
    let onHover: Bool
    
    @State private var number = Int.random(in: 0..<10)
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
            
            WebImage(url: self.movie.posterURL)
                .resizable()
                .placeholder {
                    ZStack {
                        
                        Rectangle().foregroundColor(data.color[number].opacity(0.5))
                        
                        if movie.posterPath == nil {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 60, height: 50)
                                .foregroundColor(.secondary)
                        } else {
                            ProgressView()
                        }
                    }
                }
                .scaleEffect(movie.onHover ?? false ? 1.008 : 1)
                .aspectRatio(9/15, contentMode: .fill)
                .cornerRadius(8)
            
            Color.black.opacity(onHover ? 0.2 : 0)
                .aspectRatio(9/15, contentMode: .fit)
                .cornerRadius(8)
            
            ZStack {
                Circle()
                    .frame(width: 52, height: 52)
                    .foregroundColor(Color(.black).opacity(0.9))
                
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color(.gray).opacity(0.7), lineWidth: 4)
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
        .shadow(color: Color.black.opacity(0.3), radius: onHover ? 4 : 3, x: 2, y: 3)
        .padding(.vertical)
        .animation(nil)
        
    }
    
    func getPercent(current : CGFloat) -> String {
        
        let per = current * 10
        
        return String(format: "%.0f", per)
    }
}
