//
//  SearchView.swift
//  TMDB_App
//
//  Created by Nazildo Souza on 12/08/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    
    @StateObject private var movieSearchState = MovieSearchState()
    
    var mediaType: [String: [Movie]]? {
        if movieSearchState.movies != nil {
            return Dictionary(grouping: movieSearchState.movies!.sorted(by: { $0.title ?? $0.name ?? "Desconhecido" < $1.title ?? $1.name ?? "Desconhecido" }), by: { $0.mediaType?.description ?? "Outros" })
        }
        return nil
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                
                Spacer().frame(height: 90)
                
                LoadingView(isLoading: self.movieSearchState.isLoading, error: self.movieSearchState.error) {
                    self.movieSearchState.search(query: self.movieSearchState.query)
                }
                
                if self.movieSearchState.movies != nil {
                    /*
                    ForEach(self.movieSearchState.movies!) { movie in
                        NavigationLink(destination: MovieDetailView(movieId: movie.id, media: movie.mediaType!, personLink: .navigation)) {
                            
                            HStack(alignment: .top, spacing: 15) {
                                AnimatedImage(url: movie.mediaType == .person ? movie.profileURL : movie.posterURL)
                                    .resizable()
                                    .placeholder {
                                        ZStack {
                                            Rectangle().foregroundColor(Color(.systemGray4))
                                            Image(systemName: "photo")
                                                .resizable()
                                                .frame(width: 60, height: 50)
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
                                    
                                    Text(movie.yearText != "n/a" ? movie.yearText : (movie.yearTextSerie != "n/a" ? movie.yearTextSerie : movie.knownForDepartment ?? "n/a"))
                                        .foregroundColor(.secondary)
                                    
                                    Text(movie.overview ?? movie.biography ?? "")
                                        .lineLimit(3)
                                }
                                
                                Spacer()
                                
                            }
                            .padding([.horizontal, .bottom])
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    */
                    ForEach(mediaType!.keys.sorted(), id: \.self) { key in
                        
                        SearchList(mediaType: key, movies: self.mediaType![key]!)

                    }
                }
                
                if self.movieSearchState.isEmptyResults {
                    Text("Sem Resultados")
                    
                }
                
                if self.movieSearchState.query.isEmpty {
                    Text("Busque por um Filme, Série ou Pessoa...")
                        .multilineTextAlignment(.center)
                }
            }
            
            VStack {
                
                SearchBar(query: self.$movieSearchState.query)
                    .padding(.horizontal, 25)
                    .padding(.bottom)
            }
            .background(BlurView(style: .systemMaterial).clipShape(Corners(corner: [.bottomLeft, .bottomRight], size: CGSize(width: 20, height: 20))).edgesIgnoringSafeArea([.top, .horizontal]).shadow(radius: 3))
            
        }
        .onAppear {
            self.movieSearchState.startObserve()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct SearchBar: View {
    @Binding var query: String
    
    var body: some View {
        HStack {
            
            Image(systemName: "magnifyingglass")
                .padding(6)
            
            TextField("Buscar", text: $query)
            
            if !self.query.isEmpty {
                Button(action: {
                    
                    self.query = ""
                    
                }, label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .padding(.horizontal)
                })
            }
        }
        .padding(6)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(25)
        .shadow(radius: 2)
    }
}
/*
struct SearchBarView: UIViewRepresentable {
    
    let placeholder: String
    @Binding var text: String
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: self.$text)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
    
}
*/
