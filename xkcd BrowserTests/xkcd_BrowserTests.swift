//
//  xkcd_BrowserTests.swift
//  xkcd BrowserTests
//
//  Created by Eric Davis on 31/01/2022.
//

import XCTest
@testable import xkcd_Browser

class ComicNetworkingTests: XCTestCase {
    
    func test_fetchLatestComic() throws {
        let expectation = self.expectation(description: "Wait for data")
        
        //Fetch the data here
        LatestComicRequest().sendAPIRequest { response in
            switch response {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                break
            }
            
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func test_fetchComicByNumber() throws {
        let expectation = self.expectation(description: "Wait for data")
        
        ComicByNumberRequest(comicNumber: "2367").sendAPIRequest { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                break
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func test_fetchImageForComic() {
        
    }

}
