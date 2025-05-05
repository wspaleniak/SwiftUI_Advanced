//
//  CustomNavBarContainerView.swift
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

struct CustomNavBarContainerView<T: View>: View {
    
    // MARK: - Properties
    
    @State
    private var title: String = ""
    
    @State
    private var subtitle: String? = nil
    
    @State
    private var showBackButton: Bool = true
    
    let content: T
    
    // MARK: - Init
    
    init(@ViewBuilder content: () -> T) {
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: .zero) {
            CustomNavBarView(
                title: title,
                subtitle: subtitle,
                showBackButton: showBackButton
            )
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(CustomNavBarTitlePreferenceKey.self) { value in
            title = value
        }
        .onPreferenceChange(CustomNavBarSubtitlePreferenceKey.self) { value in
            subtitle = value
        }
        .onPreferenceChange(CustomNavBarBackButtonHiddenPreferenceKey.self) { value in
            showBackButton = !value
        }
    }
}

// MARK: - Preview

#Preview {
    CustomNavBarContainerView {
        ZStack {
            Color.blue
                .opacity(0.2)
                .ignoresSafeArea()
            Text("Hello, World!")
        }
    }
}
