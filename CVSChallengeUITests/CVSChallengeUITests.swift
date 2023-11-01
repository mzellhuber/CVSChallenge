//
//  CVSChallengeUITests.swift
//  CVSChallengeUITests
//
//  Created by Melissa Zellhuber on 31/10/23.
//

import XCTest

final class CVSChallengeUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSearch() {
        let searchField = app.textFields["Search Flickr"]
        searchField.tap()
        searchField.typeText("porcupine")
        
        // Wait for the images to load
        let firstImage = app.images.element(boundBy: 0)
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: firstImage, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
