//
//  MoviePersonView.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 11/12/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieDetailPersonView: View {
    
    let movie: Movie
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                Text(movie.title ?? movie.name ?? "Desconhecido")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                HStack {
                    
                    WebImage(url: movie.profileURL)
                        .resizable()
                        .placeholder {
                            ZStack {
                                Rectangle().foregroundColor(Color(.lightGray))

                                if movie.profilePath == nil {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 90, height: 100)
                                        .foregroundColor(.secondary)
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                        .aspectRatio(9/14, contentMode: .fit)
                        .frame(maxHeight: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.4), radius: 4, x: 2, y: 4)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(movie.knownForDepartment ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(movie.placeOfBirth ?? "")
                        Text(movie.birthday ?? "")
                    }
                    .font(.title3)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 0)
                }
                .padding(.leading, 40)
            }
            
     //       Divider().frame(height: 10, alignment: .center)
            
            Text(movie.biography ?? "")
                .font(.title3)
                .padding(.all)
                .padding(.horizontal, 30)
           //     .help(movie.biography ?? "")
                .layoutPriority(1)
            
        }
    }
    
}
