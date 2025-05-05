//
//  UITestingExampleViewModel.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 15/01/2025.
//



// MARK: - NOTES

// MARK: 18 - UI Testing a SwiftUI application in Xcode
///
/// - ONLY CODE



// MARK: - CODE

import Foundation

final class UITestingExampleViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published
    private(set) var isSignedIn: Bool = false
    
    @Published
    var nameText: String = ""
    
    let namePlaceholder: String = "Add your name..."
    
    // MARK: - Init
    
    init(isSignedIn: Bool) {
        self.isSignedIn = isSignedIn
    }
    
    // MARK: - Methods
    
    func signUp() {
        guard !nameText.isEmpty else {
            return
        }
        isSignedIn = true
    }
    
    func logOut() {
        nameText = ""
        isSignedIn = false
    }
}
