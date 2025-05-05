//
//  PropertyWrappers2Example.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 04/02/2025.
//



// MARK: - NOTES

// MARK: 31 - How to create custom Property Wrappers in SwiftUI 2/2
///
/// - jeśli w strukturze naszego `PropertyWrapper` mamy zmienną `value` oznaczoną jako `optional` np. `@State private var value: T?` to taka zmienna zostanie zainicjalizowana automatycznie z wartością `nil`
/// - jeśli zdefiniujemy ją w ten sposób `@State private var value: Optional<T>` to trzeba jawnie ją zainicjalizować w metodzie `init()`
/// - ma to duże znaczenie ponieważ przy użyciu pierwszego sposobu musimy przypisać wartość do zmiennej `value` zanim zainicjalizujemy resztę pól struktury - czyli w przykładzie przed zainicjalizowaniem `self.key = key` - w innym wypadku nasza zmienna `value` będzie miała wartość `nil` nawet po przypisaniu wartości
/// - w drugim sposobie kolejność jest dowolna ponieważ i tak musimy jawnie zainicjalizować wartość dla `value` - kompilator się upomni
/// - trzecim sposobem jest zdefiniowanie zmiennej tak `@State private var value: T?`
/// - a następnie przypisanie do niej wartości w ten sposób `_value = State(wrappedValue: object)`
///
/// - możemy zrobić taki `PropertyWrapper` dla którego nie będziemy musieli deklarować typu podczas tworzenia obiektu
/// - aby to zrobić musimy przekazać w metodzie `init()` struktury argument `KeyPath`
/// - w poniższym przykładzie mamy strukturę `FileManagerValues` która jest singletonem i posiada pole `userKey`
/// - pole `userKey` jest typu `FileManagerKeyPath` i jest to generyczna struktura z polami `key: String` oraz `type: T.Type`
/// - pole `type` zostało ustawione na `UserModel.self`
/// - natomiast `init()` naszego `PropertyWrapper` wygląda tak `init(_ keyPath: KeyPath<FileManagerValues, FileManagerKeyPath<T>>)`
/// - dzięki temu typ jakim jest `UserModel` został przekazany w metodzie `init()` i kompilator wie jakiego typu jest cały `PropertyWrapper`
/// - typ został zadeklarowany w momencie przekazania argumentu `@FileManagerCodable(\.userKey)`
///
/// - **COMBINE**
/// - najpierw dodajemy zmienną prywatną np. `private let publisher: CurrentValueSubject<T?, Never>` którą inicjalizujemy w inicie wartością początkową w ten sposób `publisher = CurrentValueSubject(object)`
/// - następnie musimy przy każdej zmianie wartości naszego `PropertyWrapper` wysłać nową zmienną do subskrybentów `publisher.send(newValue)`
/// - utworzony `Publisher` udostępniamy tak `var projectedValue: CurrentValueSubject<T?, Never> { publisher }`
/// - do publishera w kodzie odwołujemy się za pomocą znaku `$` np. `$user` gdzie `user` jest obiektem `PropertyWrapper`
///
/// - **ASYNC AWAIT**
/// - możemy nasłuchiwać na utworzony powyżej `Publisher`i jego asynchroniczny strumień wartości odwołując się w kodzie do np. `$user.values` za pomocą `for-in`
///
/// - **BINDING** && **COMBINE** && **ASYNC AWAIT**
/// - żeby mieć jednocześnie dostęp do wszystkich powyższych musimy zrobić customową strukturę która będzie typem dla `projectedValue`
/// - taka struktura będzie zawierać pola:
/// - `let binding: Binding<T?>`
/// - `let publisher: CurrentValueSubject<T?, Never>`
/// - `var stream: AsyncPublisher<CurrentValueSubject<T?, Never>> { publisher.values }`
/// - w kodzie odwołujemy się do tych wartości w ten sposób `$user.binding` oraz `$user.publisher` oraz `$user.stream`



// MARK: - CODE

import Combine
import SwiftUI

// MARK: Uppercased property wrapper
@propertyWrapper
struct Uppercased: DynamicProperty {
    
    // MARK: - Properties
    
    @State private var value: String
    
    var wrappedValue: String {
        get { value.uppercased() }
        nonmutating set { value = newValue }
    }
    
    var projectedValue: Binding<String> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    // MARK: - Init
    
    init(wrappedValue: String) {
        value = wrappedValue
    }
}



// MARK: File Manager Codable property wrapper
@propertyWrapper
struct FileManagerCodable<T: Codable>: DynamicProperty {
    
    // MARK: - Properties
    
    @State private var value: T?
    
    private let key: String
    
    var wrappedValue: T? {
        get { value }
        nonmutating set { save(newValue) }
    }
    
    var projectedValue: Binding<T?> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    // MARK: - Init
    
    init(_ key: String) {
        self.key = key
        do {
            let url = FileManager.documentsPath(key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
        } catch {
            _value = State(wrappedValue: nil)
            print(error.localizedDescription)
        }
    }
    
    init(_ keyPath: KeyPath<FileManagerValues, FileManagerKeyPath<T>>) {
        self.key = FileManagerValues.shared[keyPath: keyPath].key
        do {
            let url = FileManager.documentsPath(key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(wrappedValue: object)
        } catch {
            _value = State(wrappedValue: nil)
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Methods
    
    private func save(_ newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue)
            try data.write(to: FileManager.documentsPath(key))
            value = newValue
        } catch {
            print(error.localizedDescription)
        }
    }
}



struct UserModel: Codable {
    let name: String
    let age: Int
    let isPremium: Bool
}

struct FileManagerKeyPath<T: Codable> {
    let key: String
    let type: T.Type
}

struct FileManagerValues {
    static let shared = FileManagerValues()
    let userKey = FileManagerKeyPath(
        key: "user_key",
        type: UserModel.self
    )
}



/// **COMBINE**
/// **ASYNC AWAIT**
// MARK: File Manager Codable Streamable property wrapper
@propertyWrapper
struct FileManagerCodableStreamable<T: Codable>: DynamicProperty {
    
    // MARK: - Properties
    
    @State private var value: T?
    
    private let publisher: CurrentValueSubject<T?, Never>
    
    private let key: String
    
    var wrappedValue: T? {
        get { value }
        nonmutating set { save(newValue) }
    }
    
    var projectedValue: CurrentValueSubject<T?, Never> {
        publisher
    }
    
    // MARK: - Init
    
    init(_ key: String) {
        self.key = key
        do {
            let url = FileManager.documentsPath(key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            publisher = CurrentValueSubject(object)
            _value = State(wrappedValue: object)
        } catch {
            publisher = CurrentValueSubject(nil)
            _value = State(wrappedValue: nil)
            print(error.localizedDescription)
        }
    }
    
    init(_ keyPath: KeyPath<FileManagerValues, FileManagerKeyPath<T>>) {
        self.key = FileManagerValues.shared[keyPath: keyPath].key
        do {
            let url = FileManager.documentsPath(key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            publisher = CurrentValueSubject(object)
            _value = State(wrappedValue: object)
        } catch {
            publisher = CurrentValueSubject(nil)
            _value = State(wrappedValue: nil)
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Methods
    
    private func save(_ newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue)
            try data.write(to: FileManager.documentsPath(key))
            publisher.send(newValue)
            value = newValue
        } catch {
            print(error.localizedDescription)
        }
    }
}



/// **BINDING**
/// **COMBINE**
/// **ASYNC AWAIT**
// MARK: File Manager Codable Streamable property wrapper
@propertyWrapper
struct FileManagerCodableBindingStreamable<T: Codable>: DynamicProperty {
    
    // MARK: - Properties
    
    @State private var value: T?
    
    private let publisher: CurrentValueSubject<T?, Never>
    
    private let key: String
    
    var wrappedValue: T? {
        get { value }
        nonmutating set { save(newValue) }
    }
    
    var projectedValue: CustomProjectedValue<T> {
        CustomProjectedValue(
            binding: Binding(
                get: { wrappedValue },
                set: { wrappedValue = $0 }
            ),
            publisher: publisher
        )
    }
    
    // MARK: - Init
    
    init(_ key: String) {
        self.key = key
        do {
            let url = FileManager.documentsPath(key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            publisher = CurrentValueSubject(object)
            _value = State(wrappedValue: object)
        } catch {
            publisher = CurrentValueSubject(nil)
            _value = State(wrappedValue: nil)
            print(error.localizedDescription)
        }
    }
    
    init(_ keyPath: KeyPath<FileManagerValues, FileManagerKeyPath<T>>) {
        self.key = FileManagerValues.shared[keyPath: keyPath].key
        do {
            let url = FileManager.documentsPath(key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            publisher = CurrentValueSubject(object)
            _value = State(wrappedValue: object)
        } catch {
            publisher = CurrentValueSubject(nil)
            _value = State(wrappedValue: nil)
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Methods
    
    private func save(_ newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue)
            try data.write(to: FileManager.documentsPath(key))
            publisher.send(newValue)
            value = newValue
        } catch {
            print(error.localizedDescription)
        }
    }
}



struct CustomProjectedValue<T: Codable> {
    let binding: Binding<T?>
    let publisher: CurrentValueSubject<T?, Never>
    var stream: AsyncPublisher<CurrentValueSubject<T?, Never>> {
        publisher.values
    }
}



struct PropertyWrappers2Example: View {
    
    // MARK: - Properties
    
    @Uppercased
    private var title: String = "default"
    
    @FileManagerCodable("user_model")
    private var user: UserModel?
    
    @FileManagerCodable(\.userKey)
    private var newUser
    
    @FileManagerCodableStreamable(\.userKey)
    private var superUser
    
    @FileManagerCodableBindingStreamable(\.userKey)
    private var superHiperUser
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 60) {
            VStack(spacing: 20) {
                Text(title)
                Button("Change title") {
                    title = "new title"
                }
            }
            
            // BINDING
            PropertyWrappers2ExampleChild(
                user: $newUser
            )
            
            // COMBINE && ASYNC AWAIT
            Button("Add combine and async await user") {
                superUser = .init(
                    name: "Lola",
                    age: 20,
                    isPremium: false
                )
            }
            
            // BINDING && COMBINE && ASYNC AWAIT
            PropertyWrappers2ExampleChild(
                user: $superHiperUser.binding
            )
        }
        // COMBINE
        .onReceive($superUser) { value in
            guard let value else { return }
            print("publisher emits new value: \(value)")
        }
        // ASYNC AWAIT
        .task {
            for await value in $superUser.values {
                guard let value else { return }
                print("async stream new value: \(value)")
            }
        }
        // BINDING && COMBINE && ASYNC AWAIT
        .onReceive($superHiperUser.publisher) { value in
            guard let value else { return }
            print("super hiper publisher emits new value: \(value)")
        }
        .task {
            for await value in $superHiperUser.stream {
                guard let value else { return }
                print("super hiper async stream new value: \(value)")
            }
        }
        .onAppear { print(NSHomeDirectory()) } // url do zapisywanych elementów żeby podejrzeć zapisane pliki
    }
}



struct PropertyWrappers2ExampleChild: View {
    
    // MARK: - Properties
    
    @Binding
    private(set) var user: UserModel?
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text(user?.name ?? "Brak nazwy")
                Text(user?.age.description ?? "Brak wieku")
                Text(user?.isPremium.description ?? "Brak danych")
            }
            Button("Add new user") {
                user = .init(
                    name: "Henry",
                    age: 29,
                    isPremium: true
                )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PropertyWrappers2Example()
}
