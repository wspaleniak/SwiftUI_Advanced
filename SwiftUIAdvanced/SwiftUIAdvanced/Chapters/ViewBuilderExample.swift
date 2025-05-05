//
//  ViewBuilderExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 13/11/2024.
//



// MARK: - NOTES

// MARK: 9 - How to use @ViewBuilder in SwiftUI
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

struct ViewBuilderExampleHeaderView<T: View>: View {
    
    // MARK: - Enums
    
    enum ViewType {
        case one, two
    }
    
    // MARK: - Properties
    
    let type: ViewType
    
    let title: String
    
    let content: T
    
    // MARK: - Init
    
    init(type: ViewType, title: String, @ViewBuilder content: () -> T) {
        self.type = type
        self.title = title
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.semibold)
        content
        bottomSection
        Rectangle()
            .frame(height: 1)
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var bottomSection: some View {
        switch type {
        case .one:
            Text("Bottom section...")
                .font(.headline)
        case .two:
            HStack {
                Image(systemName: "heart")
                Image(systemName: "heart.fill")
                Image(systemName: "bolt")
                Image(systemName: "bolt.fill")
            }
        }
    }
}



struct ViewBuilderExample: View {
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            ViewBuilderExampleHeaderView(type: .one, title: "Section 1") {
                HStack {
                    Text("Description")
                    Image(systemName: "heart")
                }
            }
            ViewBuilderExampleHeaderView(type: .two, title: "Section 2") {
                Text("Super combo elo...")
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

// MARK: - Preview

#Preview {
    ViewBuilderExample()
}
