//
//  CustomNavView.swift
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

struct CustomNavView<T: View>: View {
    
    // MARK: - Properties
    
    let content: T
    
    // MARK: - Init
    
    init(@ViewBuilder content: () -> T) {
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            CustomNavBarContainerView {
                content
            }
        }
    }
}



extension UINavigationController {
    
    // MARK: - Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: - Preview

#Preview {
    CustomNavView {
        ZStack {
            Color.blue
                .opacity(0.2)
                .ignoresSafeArea()
            Text("Hello, World!")
        }
    }
}
