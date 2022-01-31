//
//  xkcd_BrowserTests.swift
//  xkcd BrowserTests
//
//  Created by Eric Davis on 31/01/2022.
//

import XCTest
@testable import xkcd_Browser

class ComicNetworkingTests: XCTestCase {
    
    func testFetchComics() throws {
        let expectation = self.expectation(description: "Wait for data")
        
        //Fetch the data here
        
        waitForExpectations(timeout: 1, handler: nil)
    }

}
