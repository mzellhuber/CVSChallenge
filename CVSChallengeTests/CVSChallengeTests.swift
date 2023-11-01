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
    
    override func setUp() {
        super.setUp()
        mockService = MockFlickrService()
        viewModel = FlickrSearchViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchImagesSuccess() {
        let expectation = self.expectation(description: "Fetching Images Success")
        mockService.mockItems = [Item(title: "Test", link: "http://test.com", media: Media(m: "http://test.com/image.jpg"), description: "Test Description", author: "Test Author", authorID: "12345", tags: "test")]
        
        viewModel.fetchImages(with: "test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNotNil(self.viewModel.items)
            XCTAssert(self.viewModel.items.count == 1)
            XCTAssertNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchImagesFailure() {
        let expectation = self.expectation(description: "Fetching Images Failure")
        mockService.mockError = "Error fetching data"
        
        viewModel.fetchImages(with: "test")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssert(self.viewModel.items.isEmpty)
            XCTAssertNotNil(self.viewModel.error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

class MockFlickrService: FlickrServiceProtocol {
    var mockItems: [Item]?
    var mockError: String?
    
    func fetchImages(with tags: String, completion: @escaping ([Item]?) -> Void) {
        if let error = mockError {
            completion(nil)
        } else {
            completion(mockItems)
        }
    }
}
