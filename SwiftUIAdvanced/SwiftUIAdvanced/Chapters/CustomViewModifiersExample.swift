//
//  CustomViewModifiersExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 27/10/2024.
//



// MARK: - NOTES

// MARK: 1 - How to create custom ViewModifiers in SwiftUI
///
/// - customowy view modifier musi być zgodny z protokołem `ViewModifier`
/// - oraz implementować metodę `body(content: Content) -> some View`
/// - argument `content` przechowuje istniejący obiekt na którym modyfikator jest wywoływany
/// - aby użyć nowego modyfikatora na widoku używamy modyfikatora `.modifier(...)`
/// - możemy również stworzyć swoją własną nazwę modyfikatora żeby nie używać `.modifier(...)`
/// - w tym celu rozszerzamy typ `View` i tworzymy własną metodę zwracającą typ `some View`
/// - możemy również customować stworzony modyfikator dodając do niego properties
/// - dobrze jest tworzyć properties jako `var` z przypisaną defaultową wartością



// MARK: - CODE

import SwiftUI

struct CustomButtonViewModifier: ViewModifier {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    
    // MARK: - Methods
    
    func body(content: Content) -> some View {
        content
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            )
            .shadow(radius: 6)
    }
}



extension View {
    
    // MARK: - Methods
    
    func customButtonStyle(backgroundColor: Color) -> some View {
        modifier(
            CustomButtonViewModifier(
                backgroundColor: backgroundColor
            )
        )
    }
}



struct CustomViewModifiersExample: View {
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text("Dzień dobry!")
                .font(.headline)
                .customButtonStyle(backgroundColor: .indigo) // opcja z własną nazwą modyfikatora
            Text("Good morning!")
                .font(.subheadline)
                .modifier(CustomButtonViewModifier(backgroundColor: .blue)) // opcja bez własnej nazwy modyfikatora
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    CustomViewModifiersExample()
}
