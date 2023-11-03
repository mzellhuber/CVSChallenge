//
//  ErrorView.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 02/11/23.
//

import SwiftUI

struct ErrorView: View {
    let error: String
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text(error)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            Button("Retry", action: retryAction)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
    }
}
