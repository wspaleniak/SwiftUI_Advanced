//
//  PreferenceKeyExample2.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 16/11/2024.
//



// MARK: - NOTES

// MARK: 10 - Use PreferenceKey to extract values from child views in SwiftUI / PART 2
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    
    // MARK: - Properties
    
    static var defaultValue: CGSize = .zero
    
    // MARK: - Methods
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}



extension View {
    
    // MARK: - Methods
    
    func readSize(_ onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}



struct PreferenceKeyExample2: View {
    
    // MARK: - Properties
    
    @State
    private var rectSize: CGSize = .zero
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text("Hello world!")
                .frame(width: rectSize.width, height: rectSize.height)
                .background(.blue)
                .padding()
            Spacer()
            HStack {
                Rectangle()
                Rectangle()
                    .readSize { rectSize = $0 }
            }
            .frame(height: 60)
        }
    }
}

// MARK: - Preview

#Preview {
    PreferenceKeyExample2()
}
