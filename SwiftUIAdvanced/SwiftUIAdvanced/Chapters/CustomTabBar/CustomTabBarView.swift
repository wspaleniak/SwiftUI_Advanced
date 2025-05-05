//
//  CustomTabBarView.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 17/11/2024.
//



// MARK: - NOTES

// MARK: 11 - Create a custom tab bar in SwiftUI
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

struct CustomTabBarView: View {
    
    // MARK: - Preoperties
    
    let items: [CustomTabBarType]
    
    @Binding
    var selection: CustomTabBarType
    
    @Namespace
    private var namespace
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) {
                tabBarItemView($0)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.white)
                .shadow(color: .black.opacity(0.5), radius: 10, y: 4)
        )
        .padding(.horizontal)
        .background(.clear)
        .animation(.smooth, value: selection)
    }
    
    // MARK: - Methods
    
    private func tabBarItemView(_ type: CustomTabBarType) -> some View {
        VStack {
            Image(systemName: type.iconName)
                .font(.subheadline)
            Text(type.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .foregroundStyle(selection == type ? type.color : .gray)
        .background {
            if selection == type {
                RoundedRectangle(cornerRadius: 10)
                    .fill(type.color.opacity(0.2))
                    .matchedGeometryEffect(id: "selection", in: namespace)
            }
        }
        .contentShape(.rect)
        .onTapGesture { selection = type }
    }
}

// MARK: - Preview

#Preview {
    CustomTabBarView(
        items: [.home, .favorites, .profile],
        selection: .constant(.home)
    )
}
