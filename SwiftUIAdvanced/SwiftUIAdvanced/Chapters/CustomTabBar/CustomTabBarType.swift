//
//  CustomTabBarType.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 17/11/2024.
//



// MARK: - NOTES

// MARK: 11 - Create a custom tab bar in SwiftUI
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

enum CustomTabBarType: Hashable {
    case home
    case favorites
    case profile
    
    var iconName: String {
        switch self {
        case .home: "house.fill"
        case .favorites: "heart.fill"
        case .profile: "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home: "Home"
        case .favorites: "Favorites"
        case .profile: "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home: .blue
        case .favorites: .purple
        case .profile: .red
        }
    }
}
