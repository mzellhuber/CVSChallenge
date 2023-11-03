//
//  ImageDetailView.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import SwiftUI

struct ImageThumbnailView: View {
    let item: Item

    var body: some View {
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
    }
}
