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
    @MainActor
    func fetchImages(with tags: String) {
        isLoading = true
        error = nil
        
        Task {
            do {
                items = try await service.fetchImages(with: tags)
            } catch {
                self.error = "Failed to fetch images. Please try again."
            }
            isLoading = false
        }
    }
    
    /// Parses the image size from the HTML description of an image.
    /// - Parameter description: The HTML description containing the image size details.
    /// - Returns: A tuple containing the width and height of the image if they can be parsed, or `nil` if not.
    func parseImageSize(from description: String) -> (width: Int, height: Int)? {
        let pattern = "<img src=\"[^\"]*\" width=\"(\\d+)\" height=\"(\\d+)\""
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let nsrange = NSRange(description.startIndex..<description.endIndex, in: description)
        
        if let match = regex?.firstMatch(in: description, options: [], range: nsrange) {
            let widthRange = Range(match.range(at: 1), in: description)!
            let heightRange = Range(match.range(at: 2), in: description)!
            
            if let width = Int(description[widthRange]), let height = Int(description[heightRange]) {
                return (width, height)
            }
        }
        return nil
    }
    
    /// Strips HTML content from a string to return plain text.
    /// - Parameter string: The HTML string to be stripped.
    /// - Returns: A `String` containing the text without any HTML tags.
    func stripHTML(from string: String) -> String {
        guard let data = string.data(using: .utf8) else {
            return string
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        return attributedString?.string ?? string
    }
}
