//
//  CustomNavBarPreferenceKeys.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 18/11/2024.
//



// MARK: - NOTES

// MARK: 12 - Create a custom navigation bar and link in SwiftUI
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

struct CustomNavBarTitlePreferenceKey: PreferenceKey {
    
    // MARK: - Properties
    
    static var defaultValue: String = ""
    
    // MARK: - Methods
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}



struct CustomNavBarSubtitlePreferenceKey: PreferenceKey {
    
    // MARK: - Properties
    
    static var defaultValue: String? = nil
    
    // MARK: - Methods
    
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
}



struct CustomNavBarBackButtonHiddenPreferenceKey: PreferenceKey {
    
    // MARK: - Properties
    
    static var defaultValue: Bool = false
    
    // MARK: - Methods
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}



extension View {
    
    // MARK: - Methods
    
    func customNavBarItems(
        title: String = "",
        subtitle: String? = nil,
        backButtonHidden: Bool = false
    ) -> some View {
        self
            .customNavBarTitle(title)
            .customNavBarSubtitle(subtitle)
            .customNavBarBackButtonHidden(backButtonHidden)
    }
    
    private func customNavBarTitle(_ title: String) -> some View {
        preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
    }
    
    private func customNavBarSubtitle(_ subtitle: String?) -> some View {
        preference(key: CustomNavBarSubtitlePreferenceKey.self, value: subtitle)
    }
    
    private func customNavBarBackButtonHidden(_ hidden: Bool) -> some View {
        preference(key: CustomNavBarBackButtonHiddenPreferenceKey.self, value: hidden)
    }
}
