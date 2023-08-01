//
//  NewsTests.swift
//  NewsTests
//
//  Created by Abdelrahman on 30/07/2023.
//

@testable import News // Import your app's module name here

import XCTest

class NetworkManagerTests: XCTestCase {

    func testGetTopNews() {
        // Given
        let manager = NetworkManager.shared
        let expectation = XCTestExpectation(description: "Top news data fetched")

        // When
        manager.getTopNews { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertGreaterThan(response.articles.count, 0)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error occurred: \(error)")
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testSearch() {
        // Given
        let manager = NetworkManager.shared
        let query = "Apple"
        let expectation = XCTestExpectation(description: "Search results fetched")

        // When
        manager.search(q: query) { result in
            // Then
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertGreaterThan(response.articles.count, 0)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error occurred: \(error)")
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
