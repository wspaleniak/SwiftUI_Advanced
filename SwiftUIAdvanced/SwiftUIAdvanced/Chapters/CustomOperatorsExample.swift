//
//  CustomOperatorsExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 07/02/2025.
//



// MARK: - NOTES

// MARK: 33 - How to create custom Operators in Swift
///
/// - bardzo rzadko używane w produkcyjnych appkach ale dobrze wiedzieć jak działa
/// - aby dodać nowy operator należy najpierw go zadeklarować za pomocą `infix operator`
/// - następnie tworzymy statyczną metodę która implementuje logikę dla danego operatora



// MARK: - CODE

import SwiftUI

struct CustomOperatorsExample: View {
    
    // MARK: - Properties
    
    @State
    private var value: Double = 0
    
    // MARK: - Body
    
    var body: some View {
        Text("\(value)")
            .onAppear {
                // FIRST
                // value = (5 + 7) / 2
                // value = 5 +/ 7
                
                // SECOND
                // value = (4 + 4) / 2
                // value = 4 ++/ 2
                
                // THIRD
                // value = max(100, 10)
                // value = 100 ^^^ 10
                
                // FOURTH
                let intValue: Int = 5
                // value = Double(intValue)
                value = intValue => Double.self
            }
    }
}



infix operator +/
infix operator ++/
infix operator ^^^

extension FloatingPoint {
    
    // FIRST
    static func +/ (lhs: Self, rhs: Self) -> Self {
        (lhs + rhs) / 2
    }
    
    // SECOND
    static func ++/ (lhs: Self, rhs: Self) -> Self {
        (lhs + lhs) / rhs
    }
    
    // THIRD
    static func ^^^ (lhs: Self, rhs: Self) -> Self {
        max(lhs, rhs)
    }
}



// FOURTH
protocol InitFromBinaryInteger {
    init<T>(_ value: T) where T: BinaryInteger
}

extension Double: InitFromBinaryInteger { }

infix operator =>

extension BinaryInteger {
    static func => <T: InitFromBinaryInteger>(value: Self, newType: T.Type) -> T {
        T(value)
    }
}

// MARK: - Preview

#Preview {
    CustomOperatorsExample()
}
