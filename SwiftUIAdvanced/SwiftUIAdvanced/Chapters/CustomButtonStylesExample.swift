//
//  CustomButtonStylesExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 27/10/2024.
//



// MARK: - NOTES

// MARK: 2 - How to create custom ButtonStyles in SwiftUI
///
/// - aby stworzyć nowy styl dla przycisku tworzymy strukturę zgodną z protokołem `ButtonStyle`
/// - musi ona implementować metodę `makeBody(configuration: Configuration) -> some View`
/// - argument `configuration` zawiera informacje o tym czy przycisk jest wciśnięty `.isPressed`, rolę przycisku `.role` oraz widok `.label`



// MARK: - CODE

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    
    // MARK: - Methods
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .font(.headline)
            .foregroundColor(.white)
            .background(
                Capsule().fill(backgroundColor)
            )
            .shadow(color: backgroundColor, radius: 6)
            .opacity(configuration.isPressed ? 0.95 : 1.0)
            .brightness(configuration.isPressed ? 0.05 : 0.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}



extension ButtonStyle where Self == CustomButtonStyle {
    
    // MARK: - Methods
    
    static func blueCustomButtonStyle() -> Self {
        CustomButtonStyle(backgroundColor: .blue)
    }
}



struct CustomButtonStylesExample: View {
    
    // MARK: - Body
    
    var body: some View {
        Button("Click Me!") { }
            .buttonStyle(.blueCustomButtonStyle())
            .padding()
    }
}

// MARK: - Preview

#Preview {
    CustomButtonStylesExample()
}
