//
//  PropertyWrappersExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 03/02/2025.
//



// MARK: - NOTES

// MARK: 30 - How to create custom Property Wrappers in SwiftUI 1/2
///
/// - w uproszczeniu `PropertyWrapper` można porównać do `Binding` ale przechowującego wartość
/// - możemy tworzyć `PropertyWrapper` gdy chcemy aby po przypisaniu danej wartości wykonała się określona logika
/// - jeśli mamy strukturę która posiada metody zmieniające jej pola to metody muszą być oznaczone jako `mutating`
/// - natomiast jeśli chcemy modyfikować pola tej struktury z poziomu rodzica oraz nie oznaczać obiektu tej struktury w rodzicu jako `@State` to nie możemy oznaczyć metod jako `mutating` - niestety wtedy będziemy mieć w strukturze błąd że metoda modyfikująca pole musi być oznaczona słowem `mutating`
/// - żeby błędy zniknęły musimy takie modyfikowane pole w strukturze oznaczyć jako `@State`
/// - niestety wtedy widok rodzica nie będzie się aktualizował po modyfikacji oznaczonego pola ponieważ obiekt struktury nie jest oznaczony w rodzicu jako `@State`
/// - z pomocą przychodzi zgodność struktury z protokołem `DynamicProperty` - dzięki temu rodzic wie że struktura posiada pola oznaczone `@State` i podczas ich modyfikacji powinien przerenderować widok
/// - jeżeli mamy w strukturze zmienną `computed property` która ma `get` oraz `set` ale metoda `set` nie modyfikuje struktury - to gdy z poziomu rodzica będziemy chcieli ją modyfikować to dostaniemy znowu info że nie możemy zmodyfikować tej zmiennej
/// - z pomocą przychodzi zmiana na `nonmutating set` w tejże zmiennej - wtedy kompilator wie że metoda `set` nie modyfikuje struktury
///
/// - aby utworzyć `PropertyWrapper` musimy użyć nad definicją struktury `@propertyWrapper`
/// - struktura musi wtedy posiadać pole `wrappedValue` określonego typu
/// - zmienna którą będziemy aktualizować za pomocą przypisania nowej wartości do struktury to właśnie `wrappedValue`
/// - aby móc przekazać obiekt struktury jako `Binding` ze znakiem `$` to musimy zdefiniować wewnatrz struktury zmienną `projectedValue` typu np. `Binding<String>` i określić skąd ma brać wartość oraz jaka logika ma się wykonać po przypisaniu nowej wartości
/// - jeśli metoda `init()` będzie wyglądać tak`init(wrappedValue: String)` to możemy w fajny sposób przypisywać wartość początkową do obiektu struktury `@CustomPropertyWrapper var title: String = "Default value"`
/// - obiekt możemy też zainicjalizować w rodzicu w ten sposób `@CustomPropertyWrapper var title: String` a potem w metodzie `init()` rodzica dodać `_title = CustomPropertyWrapper(wrappedValue: "DefaultValue")`
/// - możemy w metodzie `init()` struktury dodać też inne argumenty które przekażamy podczas inicjalizacji obiektu
/// - np. `init(_ key: String)` i wtedy inicjalizacja wygląda tak `@CustomPropertyWrapper("new_title") var title: String`
/// - lub w drugi sposób pokazany wyżej wyżej `_title = CustomPropertyWrapper("new_title")`



// MARK: - CODE

import SwiftUI

@propertyWrapper
struct FileManagerProperty: DynamicProperty {
    
    // MARK: - Properties
    
    @State private var value: String
    
    private let key: String
    
    var wrappedValue: String {
        get { value }
        nonmutating set { save(newValue) }
    }
    
    var projectedValue: Binding<String> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    // MARK: - Init
    
    init(wrappedValue: String, _ key: String) {
        self.key = key
        do {
            value = try String(contentsOf: FileManager.documentsPath(key), encoding: .utf8)
        } catch {
            value = wrappedValue
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Methods
    
    private func save(_ newTitle: String) {
        do {
            try newTitle.write(to: FileManager.documentsPath(key), atomically: false, encoding: .utf8)
            value = newTitle
        } catch {
            print(error.localizedDescription)
        }
    }
}



struct PropertyWrappersExample: View {
    
    // MARK: - Properties
    
    @FileManagerProperty("title1")
    private var title1: String = "Title 1"
    
    @FileManagerProperty("title2")
    private var title2: String = "Title 2"
    
    @FileManagerProperty
    private var title3: String
    
    @FileManagerProperty
    private var subtitle: String
    
    init() {
        _title3 = FileManagerProperty(wrappedValue: "Hello", "title3")
        _subtitle = FileManagerProperty(wrappedValue: "Subtitle", "subtitle")
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 60) {
            VStack(spacing: 20) {
                Text(title1)
                    .font(.largeTitle)
                Button("Change title for HELLO") {
                    title1 = "HELLO"
                }
                Button("Change title for BONJOUR") {
                    title1 = "BONJOUR"
                }
            }
            
            VStack(spacing: 20) {
                Text(title2)
                    .font(.largeTitle)
                Button("Change title for DOG") {
                    title2 = "DOG"
                }
                Button("Change title for CAT") {
                    title2 = "CAT"
                }
            }
            
            Text(title3)
                .font(.largeTitle)
            
            PropertyWrappersExampleChild(
                subtitle: $subtitle
            )
        }
    }
}



struct PropertyWrappersExampleChild: View {
    
    // MARK: - Properties
    
    @Binding
    private(set) var subtitle: String
    
    // MARK: - Body
    
    var body: some View {
        Button(subtitle) {
            subtitle = "SUPER SUBTITLE"
        }
    }
}



extension FileManager {
    
    static func documentsPath(_ key: String) -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: "\(key).txt")
    }
}

// MARK: - Preview

#Preview {
    PropertyWrappersExample()
}
