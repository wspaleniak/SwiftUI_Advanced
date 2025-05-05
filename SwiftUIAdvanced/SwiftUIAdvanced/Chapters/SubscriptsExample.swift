//
//  SubscriptsExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 06/02/2025.
//



// MARK: - NOTES

// MARK: 32 - How to use Subscripts in Swift
///
/// - rzadko używane w produkcyjnych aplikacjach ale dobrze wiedzieć jak działa
/// - nowo utworzony `Subscript` nie może przyjmować jako argument takiego samego typu jak istniejący już w danym obiekcie `Subscript`



// MARK: - CODE

import SwiftUI

struct SubscriptsExample: View {
    
    // MARK: - Properties
    
    @State
    private var data: [String] = ["One", "Two", "Three"]
    
    @State
    private var selected: String? = nil
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            ForEach(data, id: \.self) {
                Text($0)
            }
            Text("SELECTED: \(selected ?? "none")")
        }
        .onAppear {
            // FIRST
            // selected = data[1.0]
            
            // SECOND
            // selected = data["Two"]
            
            // THIRD
            let customer = SubscriptsExampleModel(
                name: "Nick",
                address: .init(
                    street: "Main Street",
                    city: .init(name: "New York", state: "New York")
                )
            )
            // selected = customer["name"]
            selected = customer[2]
        }
    }
}



// FIRST
extension Array {
    subscript(atIndex: Double) -> Element? {
        for (index, element) in self.enumerated() {
            if Double(index) == atIndex {
                return element
            }
        }
        return nil
    }
}

// SECOND
extension Array where Element == String {
    subscript(value: String) -> Element? {
        self.first(where: { $0 == value })
    }
}

// THIRD
struct SubscriptsExampleModel {
    let name: String
    let address: SubscriptsExampleAddressModel
    
    subscript(value: String) -> String {
        switch value {
        case "name": name
        case "address": "\(address.street), \(address.city.name)"
        case "city": "\(address.city.name), \(address.city.state)"
        default: fatalError()
        }
    }
    
    subscript(index: Int) -> String {
        switch index {
        case 0: name
        case 1: "\(address.street), \(address.city.name)"
        case 2: "\(address.city.name), \(address.city.state)"
        default: fatalError()
        }
    }
}

struct SubscriptsExampleAddressModel {
    let street: String
    let city: SubscriptsExampleCityModel
}

struct SubscriptsExampleCityModel {
    let name: String
    let state: String
}

// MARK: - Preview

#Preview {
    SubscriptsExample()
}
