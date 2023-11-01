//
//  FlickrResult.swift
//  CVSChallenge
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import Foundation

// MARK: - FlickrResult
struct FlickrResult: Codable {
    let title: String
    let link: String
    let description: String
    let generator: String
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let media: Media
    let description: String
    let author, authorID, tags: String

    enum CodingKeys: String, CodingKey {
        case title, link, media
        case description, author
        case authorID = "author_id"
        case tags
    }
}

// MARK: - Media
struct Media: Codable {
    let m: String
}
