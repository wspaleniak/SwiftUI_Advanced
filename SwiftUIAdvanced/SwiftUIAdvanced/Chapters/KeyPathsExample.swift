//
//  KeyPathsExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 02/02/2025.
//



// MARK: - NOTES

// MARK: 29 - How to use KeyPaths in Swift
///
/// - `KeyPath` są podobne do `Enum` ponieważ muszą mieć z góry określone `case'y`
/// - tworząc sobie obiekt przykładowej struktury `KeyPathsExampleModel` możemy się odwołać do jej pól na dwa sposoby
/// - SPOSÓB 1: `let title = item.title`
/// - SPOSÓB 2: `let title = item[keyPath: \.title]`
/// - obiekt `KeyPath` jest generyczny i wygląda tak `KeyPath<Model, Type>` gdzie `Model` to nazwa struktury do której się odwołujemy a `Type` to typ pola znajdujący się w tej strukturze
/// - pozwala to w generyczny sposób odwoływać się do modeli i ich pól z poziomu np. metod
/// - tworząc rozszerzenie dla typu `Array` możemy utworzyć metodę która pobierze `KeyPath` dla obiektu `Element` i generycznie odczyta jego typ
/// - definicja metody będzie wyglądała następująco `func sortByKeyPath<T: Comparable>(_ keyPath: KeyPath<Element, T>)`
/// - w powyższym przykładzie musimy potwierdzić zgodność `T` z protokołem `Comparable` ponieważ używamy dalej w mtodzie znaków porównania
/// - dalej już odwołujemy się do porównywanych obiektów za pomocą `KeyPath` czyli np. `$0[keyPath: keyPath]`



// MARK: - CODE

import SwiftUI

struct KeyPathsExampleModel: Identifiable {
    let id = UUID().uuidString
    let title: KeyPathsExampleTitleModel
    let count: Int
    let date: Date
}

struct KeyPathsExampleTitleModel {
    let primary: String
    let secondary: String
}



struct KeyPathsExample: View {
    
    // MARK: - Properties
    
    @State
    private var items: [KeyPathsExampleModel] = []
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    VStack(alignment: .leading) {
                        Text(item.title.primary)
                        Text(item.title.secondary)
                        Text(item.count.description)
                        Text(item.date.formatted())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            SuperStyleView()
                .superStyle(\.title, value: "SUPER HIPER TITLE")
                .superStyle(\.count, value: 999)
        }
        .onAppear {
            let array: [KeyPathsExampleModel] = [
                .init(title: .init(primary: "One", secondary: "Two"), count: 1, date: .now),
                .init(title: .init(primary: "First", secondary: "Second"), count: 3, date: .distantPast),
                .init(title: .init(primary: "Alpha", secondary: "Beta"), count: 6, date: .distantFuture),
            ]
            // MARK: Standard
            // items = array.sorted(by: { $0.count < $1.count })
            // MARK: KeyPath
            // items = array.sorted(by: { $0[keyPath: \.count] < $1[keyPath: \.count] })
            // MARK: Generic KeyPath
            items = array.sortedByKeyPath(\.title.primary, ascending: true)
        }
    }
}



// MARK: Extension for generic KeyPath
extension Array {
    
    // MARK: SORT
    mutating func sortByKeyPath<T: Comparable>(
        _ keyPath: KeyPath<Element, T>,
        ascending: Bool = true
    ) {
        sort {
            let value1 = $0[keyPath: keyPath]
            let value2 = $1[keyPath: keyPath]
            return ascending ? (value1 < value2) : (value1 > value2)
        }
    }
    
    // MARK: SORTED
    func sortedByKeyPath<T: Comparable>(
        _ keyPath: KeyPath<Element, T>,
        ascending: Bool = true
    ) -> Self {
        sorted {
            let value1 = $0[keyPath: keyPath]
            let value2 = $1[keyPath: keyPath]
            return ascending ? (value1 < value2) : (value1 > value2)
        }
    }
}



// MARK: - SUPER STYLE

// MARK: MODEL
struct SuperStyleModel {
    var title: String = "Default title"
    var count: Int = 0
}

// MARK: ENVIRONMENT
struct SuperStyleEnvironmentKey: EnvironmentKey {
    static let defaultValue = SuperStyleModel()
}

extension EnvironmentValues {
    var superStyle: SuperStyleModel {
        get { self[SuperStyleEnvironmentKey.self] }
        set { self[SuperStyleEnvironmentKey.self] = newValue }
    }
}

// MARK: KEY PATH - OPTIONAL
// protocol SuperStyleValue {
//     associatedtype Value
//     var keyPath: WritableKeyPath<SuperStyleModel, Value> { get }
// }

extension View {
    // MARK: OPTIONAL
    // func superStyle<T: SuperStyleValue>(_ keyPath: T, value: T.Value) -> some View {
    //     transformEnvironment(\.superStyle) { superStyle in
    //         superStyle[keyPath: keyPath.keyPath] = value
    //     }
    // }
    
    func superStyle<T>(_ keyPath: WritableKeyPath<SuperStyleModel, T>, value: T) -> some View {
        transformEnvironment(\.superStyle) { superStyle in
            superStyle[keyPath: keyPath] = value
        }
    }
}

// MARK: KEY PATH EXTENSION - OPTIONAL
// struct TitleSuperStyleValue: SuperStyleValue {
//     var keyPath: WritableKeyPath<SuperStyleModel, String> { \.title }
// }
// extension SuperStyleValue where Self == TitleSuperStyleValue {
//     static var title: Self { TitleSuperStyleValue() }
// }
//
// struct CountSuperStyleValue: SuperStyleValue {
//     var keyPath: WritableKeyPath<SuperStyleModel, Int> { \.count }
// }
// extension SuperStyleValue where Self == CountSuperStyleValue {
//     static var count: Self { CountSuperStyleValue() }
// }

// MARK: VIEW
struct SuperStyleView: View {
    
    // MARK: - Properties
    
    @Environment(\.superStyle)
    private var superStyle
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text(superStyle.title)
            Text(superStyle.count.description)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .background(Color.indigo)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding()
    }
}

// MARK: - Preview

#Preview {
    KeyPathsExample()
}
