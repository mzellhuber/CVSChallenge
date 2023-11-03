//
//  FlickrService.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import Foundation

protocol FlickrServiceProtocol {
    func fetchImages(with tags: String) async throws -> [Item]
}

/// A service responsible for fetching images from Flickr API.
class FlickrService: FlickrServiceProtocol {
    
    /// Shared instance of the service.
    static let shared = FlickrService()
    
    /// Fetches images from Flickr asynchronously based on the provided tags.
    /// - Parameter tags: The search tags to filter images.
    /// - Returns: An array of `Item` objects that represent the images matching the tags.
    /// - Throws: An error if the URL is invalid, the network request fails, or the decoding of the data fails.
    func fetchImages(with tags: String) async throws -> [Item] {
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let flickrResult = try JSONDecoder().decode(FlickrResult.self, from: data)
        return flickrResult.items
    }
}
