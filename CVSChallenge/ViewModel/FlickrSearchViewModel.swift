//
//  FlickrSearchViewModel.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import Foundation

/// ViewModel responsible for managing the state and interactions for the Flickr image search feature.
class FlickrSearchViewModel: ObservableObject {
    
    /// The fetched items from the Flickr API.
    @Published var items: [Item] = []
    
    /// Error message to display if fetching fails.
    @Published var error: String? = nil
    
    /// Indicates if the fetch operation is in progress.
    @Published var isLoading: Bool = false
    
    private var service: FlickrServiceProtocol
    
    /// Initializes a new instance of the ViewModel.
    /// - Parameter service: The service to use for fetching images. Defaults to `FlickrService.shared`.
    init(service: FlickrServiceProtocol = FlickrService.shared) {
        self.service = service
    }
    
    /// Fetches images based on the provided tags.
    /// - Parameter tags: The search tags to filter images.
    func fetchImages(with tags: String) {
        self.isLoading = true
        self.error = nil
        
        service.fetchImages(with: tags) { fetchedItems in
            DispatchQueue.main.async {
                self.isLoading = false
                if let items = fetchedItems {
                    self.items = items
                } else {
                    self.error = "Failed to fetch images. Please try again."
                }
            }
        }
    }
}
