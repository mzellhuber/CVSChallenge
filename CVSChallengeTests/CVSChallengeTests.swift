//
//  CVSChallengeTests.swift
//  CVSChallengeTests
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import XCTest
@testable import CVSChallenge

class FlickrSearchViewModelTests: XCTestCase {
    
    var viewModel: FlickrSearchViewModel!
    var mockService: MockFlickrService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockFlickrService()
        viewModel = FlickrSearchViewModel(service: mockService)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        try super.tearDownWithError()
    }
    
    func testFetchImagesSuccess() async {
        let expectation = XCTestExpectation(description: "Fetching Images Success")
        mockService.mockItems = [Item(title: "Test", link: "http://test.com", media: Media(m: "http://test.com/image.jpg"), description: "Test Description", author: "Test Author", authorID: "12345", tags: "test")]

        Task {
            await viewModel.fetchImages(with: "test")
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.items.count, 1)
            XCTAssertNil(self.viewModel.error)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    func testFetchImagesFailure() async {
        let expectation = XCTestExpectation(description: "Fetching Images Failure")
        mockService.mockError = "Error fetching data"

        Task {
            await viewModel.fetchImages(with: "test")
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.items.isEmpty)
            XCTAssertNotNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
}

class MockFlickrService: FlickrServiceProtocol {
    var mockItems: [Item]?
    var mockError: String?
    
    func fetchImages(with tags: String) async throws -> [Item] {
        if let error = mockError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])
        } else {
            return mockItems ?? []
        }
    }
}
