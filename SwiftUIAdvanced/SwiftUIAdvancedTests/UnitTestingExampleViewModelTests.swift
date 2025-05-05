//
//  UnitTestingExampleViewModelTests.swift
//  SwiftUIAdvancedTests
//
//  Created by Wojciech Spaleniak on 22/11/2024.
//



// MARK: - NOTES

// MARK: 17 - Unit Testing a SwiftUI application in Xcode
///
/// - ONLY CODE



// MARK: - CODE

import Combine
import XCTest
@testable import SwiftUIAdvanced

final class UnitTestingExampleViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: UnitTestingExampleViewModel?
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Overrides

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UnitTestingExampleViewModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        cancellables.removeAll()
    }
    
    // MARK: - Methods

    func test_UnitTestingExampleViewModel_isPremium_shouldBeTrue() {
        // Given
        let userIsPremium: Bool = true
        // When
        let viewModel = UnitTestingExampleViewModel(isPremium: userIsPremium)
        // Then
        XCTAssertTrue(viewModel.isPremium)
    }
    
    func test_UnitTestingExampleViewModel_isPremium_shouldBeFalse() {
        // Given
        let userIsPremium: Bool = false
        // When
        let viewModel = UnitTestingExampleViewModel(isPremium: userIsPremium)
        // Then
        XCTAssertFalse(viewModel.isPremium)
    }
    
    func test_UnitTestingExampleViewModel_isPremium_shouldBeInjectedValue() {
        // Given
        let userIsPremium: Bool = Bool.random()
        // When
        let viewModel = UnitTestingExampleViewModel(isPremium: userIsPremium)
        // Then
        XCTAssertEqual(viewModel.isPremium, userIsPremium)
    }
    
    func test_UnitTestingExampleViewModel_isPremium_shouldBeInjectedValue_stress() {
        for _ in 0..<100 {
            // Given
            let userIsPremium: Bool = Bool.random()
            // When
            let viewModel = UnitTestingExampleViewModel(isPremium: userIsPremium)
            // Then
            XCTAssertEqual(viewModel.isPremium, userIsPremium)
        }
    }
    
    func test_UnitTestingExampleViewModel_data_shouldBeEmpty() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        // Then
        XCTAssertTrue(sut.data.isEmpty)
        XCTAssertEqual(sut.data.count, .zero)
    }
    
    func test_UnitTestingExampleViewModel_data_shouldAddItem() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let item: String = "hello"
        sut.addItem(item)
        // Then
        XCTAssertTrue(!sut.data.isEmpty)
        XCTAssertFalse(sut.data.isEmpty)
        XCTAssertEqual(sut.data.count, 1)
        XCTAssertNotEqual(sut.data.count, .zero)
        XCTAssertGreaterThan(sut.data.count, .zero)
        XCTAssertTrue(sut.data.contains(item))
        XCTAssertEqual(sut.data, [item])
    }
    
    func test_UnitTestingExampleViewModel_data_shouldNotAddBlankString() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let item: String = ""
        sut.addItem(item)
        // Then
        XCTAssertTrue(sut.data.isEmpty)
        XCTAssertEqual(sut.data.count, .zero)
    }
    
    func test_UnitTestingExampleViewModel_data_shouldAddItems() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            sut.addItem("\(Int.random(in: 1000..<9999))")
        }
        // Then
        XCTAssertTrue(!sut.data.isEmpty)
        XCTAssertEqual(sut.data.count, loopCount)
    }
    
    func test_UnitTestingExampleViewModel_selectedItem_shouldStartAsNil() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        // Then
        XCTAssertNil(sut.selectedItem)
    }
    
    func test_UnitTestingExampleViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let item: String = UUID().uuidString
        sut.addItem(item)
        sut.selectItem(item) // Najpierw zaznaczamy istniejący element
        sut.selectItem(UUID().uuidString) // Potem zaznaczamy element który nie istnieje
        // Then
        XCTAssertNil(sut.selectedItem)
    }
    
    func test_UnitTestingExampleViewModel_selectedItem_shouldBeSelected() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let item: String = UUID().uuidString
        sut.addItem(item)
        sut.selectItem(item)
        // Then
        XCTAssertNotNil(sut.selectedItem)
        XCTAssertEqual(sut.selectedItem, item)
    }
    
    func test_UnitTestingExampleViewModel_selectedItem_shouldBeSelected_stress() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        var items: [String] = []
        let loopCount: Int = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            let item: String = UUID().uuidString
            items.append(item)
            sut.addItem(item)
        }
        let randomItem = items.randomElement() ?? ""
        sut.selectItem(randomItem)
        // Then
        XCTAssertNotNil(sut.selectedItem)
        XCTAssertEqual(sut.selectedItem, randomItem)
    }
    
    func test_UnitTestingExampleViewModel_saveItem_shouldThrowError_invalidData() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let item: String = ""
        // Then
        XCTAssertThrowsError(try sut.saveItem(item)) { error in
            XCTAssertEqual(error as? UnitTestingExampleViewModel.DataError, .invalidData)
        }
    }
    
    func test_UnitTestingExampleViewModel_saveItem_shouldThrowError_itemNotFound() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let item: String = "hello"
        // Then
        // OPCJA 1:
        XCTAssertThrowsError(try sut.saveItem(item)) { error in
            XCTAssertEqual(error as? UnitTestingExampleViewModel.DataError, .itemNotFound)
        }
        // OPCJA 2:
        // do {
        //     try viewModel.saveItem(item)
        // } catch {
        //     XCTAssertEqual(error as? UnitTestingExampleViewModel.DataError, .itemNotFound)
        // }
    }
    
    func test_UnitTestingExampleViewModel_saveItem_shouldSaveItem() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let item: String = "hello"
        sut.addItem(item)
        // Then
        // OPCJA 1:
        XCTAssertNoThrow(try sut.saveItem(item))
        // OPCJA 2:
        // do {
        //     try viewModel.saveItem(item)
        // } catch {
        //     XCTFail()
        // }
    }
    
    func test_UnitTestingExampleViewModel_downloadWithEscaping_shouldReturnItems() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let expectation: XCTestExpectation = .init(description: "Should return items after 2 seconds.")
        sut.$data.dropFirst().sink { _ in expectation.fulfill() }.store(in: &cancellables)
        sut.downloadWithEscaping()
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertGreaterThan(sut.data.count, .zero)
    }
    
    func test_UnitTestingExampleViewModel_downloadWithCombine_shouldReturnItems() {
        // Given
        guard let sut else {
            XCTFail()
            return
        }
        // When
        let expectation: XCTestExpectation = .init(description: "Should return items after 2 seconds.")
        sut.$data.dropFirst().sink { _ in expectation.fulfill() }.store(in: &cancellables)
        sut.downloadWithCombine()
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertGreaterThan(sut.data.count, .zero)
    }
}
