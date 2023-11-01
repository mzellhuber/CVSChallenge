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
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .accessibilityHidden(true)
                TextField("Search Flickr", text: $searchText)
                    .onChange(of: searchText) { _ in
                        viewModel.fetchImages(with: searchText)
                    }
                    .accessibilityLabel("Search Flickr for images")
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else if let error = viewModel.error {
                        VStack(spacing: 10) {
                            Text(error)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                            Button("Retry") {
                                viewModel.fetchImages(with: searchText)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding()
                    } else if viewModel.items.isEmpty {
                        SearchIndicatorView(message: searchText.isEmpty ?
                            "Start typing to search for images on Flickr." :
                            "No results found for '\(searchText)'.\nTry another search.")
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.items, id: \.link) { item in
                                    NavigationLink(destination: ImageDetailView(item: item)) {
                                        AsyncImage(url: URL(string: item.media.m)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .scaledToFill()
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .cornerRadius(8)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                        .padding(5)
                                        .accessibilityLabel("Image titled \(item.title) by \(item.author)")
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                .frame(height: geometry.size.height)
            }
        }
        .navigationTitle("Flickr Search")
    }
}

#Preview {
    ContentView()
}
