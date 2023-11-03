//
//  ContentView.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @ObservedObject var viewModel = FlickrSearchViewModel()
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText) {
                    viewModel.fetchImages(with: searchText)
                }
                
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        if viewModel.isLoading {
                            LoadingView()
                        } else if let error = viewModel.error {
                            ErrorView(error: error) {
                                viewModel.fetchImages(with: searchText)
                            }
                        } else if viewModel.items.isEmpty {
                            EmptyStateView(searchText: searchText)
                        } else {
                            ImageGridView(viewModel: viewModel, columns: [GridItem(.flexible()), GridItem(.flexible())])
                        }
                        
                        Spacer()
                    }
                    .frame(height: geometry.size.height)
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}

#Preview {
    ContentView()
}
