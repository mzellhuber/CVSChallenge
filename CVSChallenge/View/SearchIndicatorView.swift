//
//  SearchIndicatorView.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import SwiftUI

struct SearchIndicatorView: View {
    var message: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
            
            Text(message)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
#Preview {
    SearchIndicatorView(message: "test")
}
