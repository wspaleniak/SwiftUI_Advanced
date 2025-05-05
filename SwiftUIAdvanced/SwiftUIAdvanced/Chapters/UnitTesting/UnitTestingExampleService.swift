//
//  UnitTestingExampleService.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 24/11/2024.
//



// MARK: - NOTES

// MARK: 17 - Unit Testing a SwiftUI application in Xcode
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI
import Combine

protocol UnitTestingExampleServiceProtocol {
    func downloadWithEscaping(completion: @escaping ([String]) -> Void)
    func downloadWithCombine() -> AnyPublisher<[String], Never>
}



final class UnitTestingExampleService: UnitTestingExampleServiceProtocol {
    
    // MARK: - Methods
    
    func downloadWithEscaping(completion: @escaping ([String]) -> Void) {
        // Prawdziwa logika serwisu
    }
    
    func downloadWithCombine() -> AnyPublisher<[String], Never> {
        // Prawdziwa logika serwisu
        return Just([]).eraseToAnyPublisher()
    }
}



final class UnitTestingExampleServiceMock: UnitTestingExampleServiceProtocol {
    
    // MARK: - Properties
    
    let mockItems: [String] = ["One", "Two", "Three"]
    
    // MARK: - Methods
    
    func downloadWithEscaping(completion: @escaping ([String]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self else {
                return
            }
            completion(mockItems)
        }
    }
    
    func downloadWithCombine() -> AnyPublisher<[String], Never> {
        return Just(mockItems)
            .delay(for: 2.0, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
