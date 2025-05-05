//
//  CustomTabBarPreferenceKey.swift
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

struct CustomTabBarPreferenceKey: PreferenceKey {
    
    // MARK: - Properties
    
    static var defaultValue: [CustomTabBarType] = []
    
    // MARK: - Methods
    
    static func reduce(value: inout [CustomTabBarType], nextValue: () -> [CustomTabBarType]) {
        value += nextValue()
    }
}



struct CustomTabBarViewModifier: ViewModifier {
    
    // MARK: - Properties
    
    let type: CustomTabBarType
    
    @Binding
    var selection: CustomTabBarType
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == type ? 1.0 : 0.0)
            .preference(key: CustomTabBarPreferenceKey.self, value: [type])
    }
}



extension View {
    
    // MARK: - Methods
    
    func tabBarItem(_ type: CustomTabBarType, selection: Binding<CustomTabBarType>) -> some View {
        modifier(CustomTabBarViewModifier(type: type, selection: selection))
    }
}
