//
//  UnitTestingExampleViewModel.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 21/11/2024.
//



// MARK: - NOTES

// MARK: 17 - Unit Testing a SwiftUI application in Xcode
///
/// - ONLY CODE



// MARK: - CODE

import Combine
import SwiftUI

final class UnitTestingExampleViewModel: ObservableObject {
    
    // MARK: - Enums
    
    enum DataError: LocalizedError {
        case invalidData
        case itemNotFound
    }
    
    // MARK: - Properties
    
    @Published
    private(set) var isPremium: Bool
    
    @Published
    private(set) var data: [String] = []
    
    @Published
    private(set) var selectedItem: String? = nil
    
    let dataService: UnitTestingExampleServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(
        isPremium: Bool,
        dataService: UnitTestingExampleServiceProtocol = UnitTestingExampleServiceMock()
    ) {
        self.isPremium = isPremium
        self.dataService = dataService
    }
    
    // MARK: - Methods
    
    func addItem(_ item: String) {
        guard !item.isEmpty else {
            return
        }
        data.append(item)
    }
    
    func selectItem(_ item: String) {
        if let existingItem = data.first(where: { $0 == item }) {
            selectedItem = existingItem
        } else {
            selectedItem = nil
        }
    }
    
    func saveItem(_ item: String) throws {
        guard !item.isEmpty else {
            throw DataError.invalidData
        }
        guard let existingItem = data.first(where: { $0 == item }) else {
            throw DataError.itemNotFound
        }
        print("Item \(existingItem) saved successfully.")
    }
    
    func downloadWithEscaping() {
        dataService.downloadWithEscaping { [weak self] data in
            self?.data = data
        }
    }
    
    func downloadWithCombine() {
        dataService.downloadWithCombine()
            .assign(to: \.data, on: self)
            .store(in: &cancellables)
    }
}
