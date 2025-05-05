//
//  CustomNavLink.swift
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

struct CustomNavLink<T, U>: View where T: View, U: View {
    
    // MARK: - Properties
    
    let destination: T
    
    let label: U
    
    // MARK: - Init
    
    init(destination: T, @ViewBuilder label: () -> U) {
        self.destination = destination
        self.label = label()
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationLink(
            destination: destinationView,
            label: { label }
        )
    }
    
    // MARK: - Subviews
    
    private var destinationView: some View {
        CustomNavBarContainerView(content: { destination })
            .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

// MARK: - Preview

#Preview {
    CustomNavView {
        CustomNavLink(
            destination: Text("Destination"),
            label: { Text("Navigate") }
        )
    }
}
