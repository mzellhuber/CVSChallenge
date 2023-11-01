//
//  FlickrService.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import Foundation

protocol FlickrServiceProtocol {
    func fetchImages(with tags: String, completion: @escaping ([Item]?) -> Void)
}

/// A service responsible for fetching images from Flickr API.
class FlickrService: FlickrServiceProtocol {
    
    /// Shared instance of the service.
    static let shared = FlickrService()
    
    /// Fetches images from Flickr based on the provided tags.
    /// - Parameters:
    ///   - tags: The search tags to filter images.
    ///   - completion: The completion handler to call when the fetch is complete.
    func fetchImages(with tags: String, completion: @escaping ([Item]?) -> Void) {
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(tags)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let flickrResult = try JSONDecoder().decode(FlickrResult.self, from: data)
                completion(flickrResult.items)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
