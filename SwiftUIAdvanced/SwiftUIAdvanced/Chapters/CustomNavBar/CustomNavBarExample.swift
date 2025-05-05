//
//  CustomNavBarExample.swift
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

struct CustomNavBarExample: View {
    
    // MARK: - Body
    
    var body: some View {
        CustomNavView {
            ZStack {
                CustomNavLink(
                    destination: destinationView,
                    label: { Text("Navigate to new view >>") }
                )
            }
            .customNavBarItems(
                title: "Main",
                subtitle: "Main page for you",
                backButtonHidden: true
            )
        }
    }
    
    // MARK: - Subviews
    
    private var destinationView: some View {
        Text("Good morning people!")
            .customNavBarItems(
                title: "New New",
                subtitle: "New page",
                backButtonHidden: false
            )
    }
}

// MARK: - Preview

#Preview {
    CustomNavBarExample()
}
