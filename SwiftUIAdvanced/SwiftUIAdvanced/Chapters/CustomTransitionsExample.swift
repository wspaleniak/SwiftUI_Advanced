//
//  CustomTransitionsExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 05/11/2024.
//



// MARK: - NOTES

// MARK: 3 - How to create custom Transitions in SwiftUI
///
/// - aby stworzyć nowe przejście dla elementu na widoku musimy stworzyć najpierw `ViewModifier`
/// - używamy go później podczas rozszerzania typu `AnyTransition` w którym tworzymy statyczną zmienną zwracającą `Self`
/// - stworzony modyfikator używamy w metodzie `modifier(active: ViewModifier, identity: ViewModifier)`
/// - każdy stan przejścia `active` oraz `identity` zwracają widok zmodyfikowany za pomocą stworzonego `ViewModifier`
/// - cała logika jak ma się zmieniać widok zawarta jest wewnątrz stworzonego modyfikatora



// MARK: - CODE

import SwiftUI

struct RotateViewModifier: ViewModifier {
    
    // MARK: - Properties
    
    let rotation: Double
    
    // MARK: - Methods
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .offset(
                x: rotation != 0 ? UIScreen.main.bounds.width : 0,
                y: rotation != 0 ? UIScreen.main.bounds.height : 0
            )
    }
}



extension AnyTransition {
    
    // MARK: - Properties
    
    static var rotating: Self {
        modifier(
            active: RotateViewModifier(rotation: 180.0), // stan po kliknięciu przycisku
            identity: RotateViewModifier(rotation: 0.0) // stan przed kliknięciem przycisku
        )
    }
    
    static var rotateOn: Self {
        asymmetric(
            insertion: rotating, // użycie na wejście stworzonego przejścia
            removal: .move(edge: .leading)
        )
    }
    
    // MARK: - Methods
    
    static func rotating(_ value: Double) -> Self {
        modifier(
            active: RotateViewModifier(rotation: value),
            identity: RotateViewModifier(rotation: 0.0)
        )
    }
}



struct CustomTransitionsExample: View {
    
    // MARK: - Properties
    
    @State
    private var showRectangle: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            if showRectangle {
                Spacer()
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 250, height: 350)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // .transition(.rotating)
                    // .transition(.rotating(270))
                    .transition(.rotateOn)
            }
            Spacer()
            Button("Click Me!") {
                showRectangle.toggle()
            }
        }
        .animation(.bouncy, value: showRectangle)
    }
}

// MARK: - Preview

#Preview {
    CustomTransitionsExample()
}
