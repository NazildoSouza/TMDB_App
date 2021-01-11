//
//  SearchView.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 11/12/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    
    @EnvironmentObject var movieData: MovieDataView
    @ObservedObject var movieSearchState: MovieSearchState
    
    var mediaType: [String: [Movie]]? {
        if movieSearchState.movies != nil {
            return Dictionary(grouping: movieSearchState.movies!.sorted(by: { $0.title ?? $0.name ?? "Desconhecido" < $1.title ?? $1.name ?? "Desconhecido" }), by: { $0.mediaType?.description ?? "Outros" })
        }
        return nil
    }
    
    var geometryProxy: GeometryProxy
    
    var body: some View {
        
        ZStack {
            
            if self.movieSearchState.movies != nil && self.movieSearchState.movies!.count > 0 {
                
                ScrollViewReader { value in
                    ScrollView {
                        
                        ForEach(mediaType!.keys.sorted(), id: \.self) { key in
                            
                            SearchList(mediaType: key, movies: self.mediaType![key]!)
                            
                        }
                        
                    }
                    .onAppear {
                        if movieData.scrollIdSearch != nil {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                
                                
                                value.scrollTo(movieData.scrollIdSearch, anchor: .center)
                                print("teste")
                            }
                        }
                    }
                    
                }
                .transition(.fade(duration: 1))
                
            } else if self.movieSearchState.isEmptyResults {
                Text("Sem Resultados")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding(30)
                    .frame(width: geometryProxy.size.width, height: geometryProxy.size.height, alignment: .center)
                    .transition(.fade(duration: 0.5))
                
            } else {
                LoadingView(isLoading: movieSearchState.isLoading, error: movieSearchState.error) {
                    movieSearchState.search(query: movieSearchState.query)
                }
                .frame(width: geometryProxy.size.width, height: geometryProxy.size.height, alignment: .center)
                .animation(.default)
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            self.movieSearchState.startObserve()
        }
        
    }
}

struct SearchBar: View {
    @Binding var query: String
    @Binding var showSearch: Bool
    
    var body: some View {
        
        HStack(spacing: 10){
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .imageScale(.large)
            
            //                TextField("buscar", text: $query) { (edit) in
            //                    print("edit", edit)
            //                } onCommit: {
            //                    print("commit")
            //                }
            //                .focusable(showSearch, onFocusChange: { (i) in
            //                    print("focusable", i)
            //                })
            TextField("Buscar", text: $query)
                .textFieldStyle(PlainTextFieldStyle())
            
            if query != "" {
                Button(action: {
                    withAnimation(.default) {
                        query = ""
                    }
                }, label: {
                    
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                    
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 150)
        .padding(.vertical, 6)
        .padding(.horizontal)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1).opacity(0.2))
        
    }
}
