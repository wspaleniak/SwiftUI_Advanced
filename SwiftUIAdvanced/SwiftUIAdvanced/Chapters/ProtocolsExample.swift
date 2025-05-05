//
//  ProtocolsExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 20/11/2024.
//



// MARK: - NOTES

// MARK: 15 - How to use Protocols in Swift
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

protocol SuperColorThemeProtocol {
    var supercolor: Color { get set }
}



protocol ColorThemeProtocol: SuperColorThemeProtocol {
    var primary: Color { get set } // { get set } implementowana zmienna musi być VAR
    var secondary: Color { get } // { get } implementowana zmienna powinna być LET
    var tertiary: Color { get }
    func getColorThemeName() -> String
}



extension ColorThemeProtocol {
    func getColorThemeName() -> String {
        String(describing: Self.self)
    }
}



struct DefaultColorTheme: ColorThemeProtocol {
    var supercolor: Color = .yellow
    var primary: Color = .blue
    let secondary: Color = .white
    let tertiary: Color = .gray
}



struct AlternativeColorTheme: ColorThemeProtocol {
    var supercolor: Color = .indigo
    var primary: Color = .red
    let secondary: Color = .white
    let tertiary: Color = .green
}



struct AnotherColorTheme: ColorThemeProtocol {
    var supercolor: Color = .pink
    var primary: Color = .indigo
    let secondary: Color = .white
    let tertiary: Color = .yellow
}



struct ProtocolsExample: View {
    
    // MARK: - Properties
    
    let colorTheme: ColorThemeProtocol
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            colorTheme.tertiary
                .ignoresSafeArea()
            VStack {
                Text(colorTheme.getColorThemeName())
                    .padding()
                    .padding(.horizontal)
                    .font(.headline)
                    .foregroundStyle(colorTheme.secondary)
                    .background(Capsule().fill(colorTheme.primary))
                Circle()
                    .fill(colorTheme.supercolor)
                    .frame(width: 150, height: 150)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ProtocolsExample(colorTheme: AnotherColorTheme())
}
