//
//  ImageGridView.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 02/11/23.
//

import SwiftUI

struct ImageGridView: View {
    @ObservedObject var viewModel: FlickrSearchViewModel
    let columns: [GridItem]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.items, id: \.link) { item in
                    NavigationLink(destination: ImageDetailView(viewModel: viewModel, item: item)) {
                        ImageThumbnailView(item: item)
                    }
                    .accessibilityLabel("Image titled \(item.title) by \(item.author)")
                }
            }
            .padding(.horizontal)
        }
    }
}
