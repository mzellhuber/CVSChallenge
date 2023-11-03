//
//  SearchBar.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 02/11/23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .accessibilityHidden(true)
            TextField("Search Flickr", text: $searchText)
                .onChange(of: searchText) { _ in onSearch() }
                .accessibilityLabel("Search Flickr for images")
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
