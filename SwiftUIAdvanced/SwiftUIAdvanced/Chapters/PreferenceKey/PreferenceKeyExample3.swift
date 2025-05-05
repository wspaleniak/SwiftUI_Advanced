//
//  PreferenceKeyExample3.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 16/11/2024.
//



// MARK: - NOTES

// MARK: 10 - Use PreferenceKey to extract values from child views in SwiftUI / PART 3
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    
    // MARK: - Properties
    
    static var defaultValue: CGFloat = .zero
    
    // MARK: - Methods
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}



extension View {
    
    // MARK: - Methods
    
    func scrollOffsetChanged(_ onChange: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: proxy.frame(in: .global).minY
                    )
            }
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: onChange)
    }
}



struct PreferenceKeyExample3: View {
    
    // MARK: - Properties
    
    @State
    private var scrollOffset: CGFloat = .zero
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack {
                titleView
                contentView
            }
            .padding()
        }
        .overlay(alignment: .top) {
            navigationBarView
        }
        .overlay(alignment: .bottom) {
            Text("Offset = \(scrollOffset)")
        }
    }
    
    // MARK: - Subviews
    
    private var titleView: some View {
        Text("Title")
            .opacity(Double(scrollOffset) / 78.0)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .scrollOffsetChanged { scrollOffset = $0 }
    }
    
    private var contentView: some View {
        ForEach(0..<30) { _ in
            RoundedRectangle(cornerRadius: 20.0)
                .fill(.blue.opacity(0.4))
                .frame(height: 200.0)
        }
    }
    
    private var navigationBarView: some View {
        Text("Title")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.yellow)
            .opacity(scrollOffset <= -10.0 ? 1.0 : 0.0)
    }
}

// MARK: - Preview

#Preview {
    PreferenceKeyExample3()
}
