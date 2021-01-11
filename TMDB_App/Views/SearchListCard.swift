//
//  SearchListCard.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 03/10/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchListCard: View {
    var movie: Movie
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 15) {
            AnimatedImage(url: movie.mediaType == .person ? movie.profileURL : movie.posterURL)
                .resizable()
                .placeholder {
                    ZStack {
                        Rectangle().foregroundColor(Color(.systemGray4))
                        Image(systemName: movie.mediaType == .person ? "person.fill" : "photo")
                            .resizable()
                            .frame(width: movie.mediaType == .person ? 45 : 60, height: 50)
                            .foregroundColor(.secondary)
                    }
                }
                .indicator(SDWebImageActivityIndicator.medium)
                .frame(width: 100, height: 150)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title ?? movie.name ?? "Desconhecido")
                    .fontWeight(.bold)
                    .padding(.top, 5)
                
                Text(movie.yearText != "-" ? movie.yearText : (movie.yearTextSerie != "-" ? movie.yearTextSerie : movie.knownForDepartment ?? "-"))
                    .foregroundColor(.secondary)
                
                Text(movie.overview ?? movie.biography ?? "")
                    .lineLimit(3)
            }
            
            Spacer()
            
        }
        .padding([.horizontal, .bottom])
    }
}

//struct SearchListCard_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchListCard()
//    }
//}
