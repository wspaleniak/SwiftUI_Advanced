//
//  MatchedGeometryEffectExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 05/11/2024.
//



// MARK: - NOTES

// MARK: 4 - How to use MatchedGeometryEffect in SwiftUI
///
/// - `.matchedGeometryEffect(...)` pozwala zmienić jeden kształt w drugi w momencie gdy pierwszy znika i pojawia się drugi
/// - dla obu kształtów musimy ustawić ten sam `id` oraz wspólny `namespace`
/// - `namespace` to zmienna która jest oznaczona wrapperem `@Namespace`
/// - `namespace` może być wspólne dla wszystkich elementów na widoku - nawet jeśli mają różna `id`



// MARK: - CODE

import SwiftUI

struct MatchedGeometryEffectExample: View {
    
    // MARK: - Properties
    
    // EXAMPLE 1
    // @State
    // private var isTapped: Bool = false
    //
    // @Namespace
    // private var namespace
    
    // EXAMPLE 2
    @State
    private var selected: String = "Home"
    
    @Namespace
    private var namespace
    
    private let categories: [String] = [
        "Home", "Popular", "Saved"
    ]
    
    // MARK: - Body
    
    var body: some View {
        // EXAMPLE 1
        // VStack {
        //     if !isTapped {
        //         Circle()
        //             .matchedGeometryEffect(id: "shape", in: namespace)
        //             .frame(width: 120, height: 120)
        //     }
        //     Spacer()
        //     if isTapped {
        //         RoundedRectangle(cornerRadius: 30)
        //             .matchedGeometryEffect(id: "shape", in: namespace)
        //             .frame(width: 200, height: 200)
        //     }
        // }
        // .frame(maxWidth: .infinity, maxHeight: .infinity)
        // .background(.blue.opacity(0.3))
        // .onTapGesture { isTapped.toggle() }
        // .animation(.smooth, value: isTapped)
        
        // EXAMPLE 2
        HStack {
            ForEach(categories, id: \.self) { category in
                ZStack {
                    if selected == category {
                        Capsule()
                            .fill(.gray.opacity(0.3))
                            .matchedGeometryEffect(id: "category", in: namespace)
                    }
                    Text(category)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .contentShape(.rect)
                .onTapGesture { selected = category }
            }
        }
        .background(
            Capsule().fill(.gray.opacity(0.1))
        )
        .animation(.smooth, value: selected)
        .padding()
    }
}

// MARK: - Preview

#Preview {
    MatchedGeometryEffectExample()
}
