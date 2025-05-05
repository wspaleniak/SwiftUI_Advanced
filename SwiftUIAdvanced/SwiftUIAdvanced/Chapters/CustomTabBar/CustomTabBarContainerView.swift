//
//  CustomTabBarContainerView.swift
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

struct CustomTabBarContainerView<T: View>: View {
    
    // MARK: - Properties
    
    @State
    private var items: [CustomTabBarType] = []
    
    @Binding
    private var selection: CustomTabBarType
    
    private let content: T
    
    // MARK: - Init
    
    init(selection: Binding<CustomTabBarType>, @ViewBuilder content: () -> T) {
        self._selection = selection
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            CustomTabBarView(
                items: items,
                selection: $selection
            )
        }
        .onPreferenceChange(CustomTabBarPreferenceKey.self) { value in
            items = value
        }
    }
}

// MARK: - Preview

#Preview {
    CustomTabBarContainerView(
        selection: .constant(.home),
        content: { Color.blue }
    )
}
