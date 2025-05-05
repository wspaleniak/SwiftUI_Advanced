//
//  UnitTestingExampleServiceTests.swift
//  SwiftUIAdvancedTests
//
//  Created by Wojciech Spaleniak on 27/11/2024.
//



// MARK: - NOTES

// MARK: 17 - Unit Testing a SwiftUI application in Xcode
///
/// - ONLY CODE



// MARK: - CODE

import Combine
import XCTest
@testable import SwiftUIAdvanced

final class UnitTestingExampleServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: UnitTestingExampleServiceMock?
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Overrides

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UnitTestingExampleServiceMock()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        cancellables.removeAll()
    }
    
    // MARK: - Methods
    
    func test_UnitTestingExampleService_downloadWithEscaping_shouldReturnItems() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        var items: [String] = []
        let expectation: XCTestExpectation = .init(description: "Should return items after 2 seconds.")
        sut.downloadWithEscaping { newItems in
            items = newItems
            expectation.fulfill()
        }
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(items.count, sut.mockItems.count)
    }
    
    func test_UnitTestingExampleService_downloadWithCombine_shouldReturnItems() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        var items: [String] = []
        let expectation: XCTestExpectation = .init(description: "Should return items after 2 seconds.")
        sut.downloadWithCombine()
            .sink { newItems in
                items = newItems
                expectation.fulfill()
            }
            .store(in: &cancellables)
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(items.count, sut.mockItems.count)
    }
}
