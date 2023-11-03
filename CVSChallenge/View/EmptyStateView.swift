//
//  EmptyStateView.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 02/11/23.
//

import SwiftUI

struct EmptyStateView: View {
    let searchText: String
    
    var body: some View {
        SearchIndicatorView(message: searchText.isEmpty ?
            "Start typing to search for images on Flickr." :
            "No results found for '\(searchText)'.\nTry another search.")
    }
}
