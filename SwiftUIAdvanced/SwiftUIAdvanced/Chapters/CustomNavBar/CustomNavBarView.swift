//
//  CustomNavBarView.swift
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

struct CustomNavBarView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss)
    private var dismiss
    
    let title: String
    
    let subtitle: String?
    
    let showBackButton: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title)
                .fontWeight(.medium)
            if let subtitle {
                Text(subtitle)
                    .font(.headline)
            }
        }
        .foregroundStyle(.white)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 50)
        .background(.blue)
        .overlay(alignment: .leading) {
            if showBackButton { backButtonView }
        }
    }
    
    // MARK: - Subviews
    
    private var backButtonView: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.headline)
                .foregroundStyle(.white)
                .padding()
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        CustomNavBarView(
            title: "Title",
            subtitle: "Subtitle",
            showBackButton: true
        )
        Spacer()
    }
}
