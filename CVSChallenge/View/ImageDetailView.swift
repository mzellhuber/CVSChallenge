//
//  ImageDetailView.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 02/11/23.
//

import SwiftUI

struct ImageDetailView: View {
    @ObservedObject var viewModel: FlickrSearchViewModel
    let item: Item
    @State private var isSharingPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: item.media.m)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: geometry.size.width)
                                .accessibilityLabel("Image titled \(item.title)")
                        case .failure(_):
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.secondary)
                                .opacity(0.6)
                                .accessibilityLabel("Failed to load image")
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(height: 300)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                )
                .shadow(radius: 7)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                        .accessibilityAddTraits(.isHeader)

                    if let imageSize = viewModel.parseImageSize(from: item.description) {
                        HStack {
                            Text("Image Size:")
                                .font(.headline)
                            Spacer()
                            Text("\(imageSize.width) x \(imageSize.height) pixels")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .accessibilityLabel("Image size: \(imageSize.width) by \(imageSize.height) pixels")
                        }
                    }

                    Text(viewModel.stripHTML(from: item.description))
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                        .accessibilityLabel("Description: \(viewModel.stripHTML(from: item.description))")

                    Divider()

                    HStack {
                        Text("Author:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(item.author)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                            .accessibilityLabel("Author: \(item.author)")
                    }

                    HStack {
                        Text("Tags:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(item.tags)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(3)
                            .truncationMode(.tail)
                            .accessibilityLabel("Tags: \(item.tags)")
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle(Text(item.title), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.isSharingPresented = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .imageScale(.large)
                .accessibilityLabel("Share")
        })
        .sheet(isPresented: $isSharingPresented) {
            ActivityView(activityItems: [URL(string: item.media.m) as Any, item.title])
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update required
    }
}
