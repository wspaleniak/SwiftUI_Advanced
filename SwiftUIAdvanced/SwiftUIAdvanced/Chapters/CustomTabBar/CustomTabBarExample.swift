//
//  CustomTabBarExample.swift
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

struct CustomTabBarExample: View {
    
    // MARK: - Properties
    
    @State
    private var selection: CustomTabBarType = .home
    
    // MARK: - Body
    
    var body: some View {
        CustomTabBarContainerView(selection: $selection) {
            Color.blue
                .tabBarItem(.home, selection: $selection)
            Color.purple
                .tabBarItem(.favorites, selection: $selection)
            Color.red
                .tabBarItem(.profile, selection: $selection)
        }
    }
}

// MARK: - Preview

#Preview {
    CustomTabBarExample()
}
