//
//  ImageDetailView.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import SwiftUI

struct ImageDetailView: View {
    let item: Item

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: URL(string: item.media.m))
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    .padding(.bottom, 20)
                Spacer()
            }
            .padding()
        }
    }
}
