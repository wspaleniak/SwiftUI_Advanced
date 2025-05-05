//
//  UITestingExampleHomeView.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 15/01/2025.
//



// MARK: - NOTES

// MARK: 18 - UI Testing a SwiftUI application in Xcode
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

struct UITestingExampleHomeView: View {
    
    // MARK: - Properties
    
    @State
    private var showAlert: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show welcome alert!")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .padding()
                        .foregroundStyle(.blue)
                        .background(
                            Capsule().stroke(.blue, lineWidth: 2)
                        )
                }
                .accessibilityIdentifier("ShowAlertButton")
                
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .padding()
                        .foregroundStyle(.white)
                        .background(
                            Capsule().fill(.blue)
                        )
                }
                .accessibilityIdentifier("NavigationLinkButton")
            }
            .navigationTitle("Welcome")
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert(
                "Welcome to the app!",
                isPresented: $showAlert,
                actions: { }
            )
        }
    }
}

// MARK: - Preview

#Preview {
    UITestingExampleHomeView()
}
