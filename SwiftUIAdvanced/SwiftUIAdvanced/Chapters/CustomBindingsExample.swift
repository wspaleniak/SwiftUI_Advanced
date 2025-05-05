//
//  CustomBindingsExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 02/02/2025.
//



// MARK: - NOTES

// MARK: 27 - Create custom Bindings in SwiftUI
///
/// - obiektu `Binding` używamy żeby móc aktualizować wartości z poziomu widoku dziecka w widoku rodzica
/// - bez użycia `Binding` możemy to robić za pomocą `closue () -> Void`
/// - w widoku dziecka możemy użyć klasycznie property wrappera `@Binding var title: String = ""`
/// - wtedy przypisujemy wartość do zmiennej tak `title = "new value"`
/// - możemy to zrobić również bez property wrappera i użyć `let title: Binding<String>`
/// - wtedy przypisujemy wartość do zmiennej tak `title.wrappedValue = "new value"`
/// - do widoku dziecka możemy przekazać zmienną `Binding` klasycznie za pomocą `$title`
/// - ale możemy również stworzyć customowy obiekt `Binding` za pomocą `Binding(get:set:)` i samemu stworzyć logikę ustawiania wartości



// MARK: - CODE

import SwiftUI

struct CustomBindingsExample: View {
    
    // MARK: - Properties
    
    @State
    private var title: String = "Start"
    
    @State
    private var errorTitle: String? = nil
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 40) {
            Text(title)
                .font(.largeTitle)
            // @Binding + $
            CustomBindingsExampleFirstChild(title: $title)
            // Constant + Closure
            CustomBindingsExampleSecondChild(title: title) { title = $0 }
            // Binding<> + $
            CustomBindingsExampleThirdChild(title: $title)
            // Binding<> + Binding(get:set:)
            CustomBindingsExampleThirdChild(
                title: Binding(
                    get: { title },
                    set: { title = $0 }
                )
            )
            
            // Example 1 & 2
            Button("Show alert") {
                errorTitle = "NEW ERROR"
            }
            .font(.title3)
            .tint(.red)
        }
        // Example 1 with custom Binding:
        // .alert(
        //     errorTitle ?? "",
        //     isPresented: Binding(
        //         get: { errorTitle != nil },
        //         set: { if !$0 { errorTitle = nil }}
        //     ),
        //     actions: { }
        // )
        //
        // Example 2 with custom init for Binding:
        .alert(
            errorTitle ?? "",
            isPresented: Binding($errorTitle),
            actions: { }
        )
    }
}



// MARK: @Binding + $
struct CustomBindingsExampleFirstChild: View {
    
    // MARK: - Properties
    
    @Binding
    private(set) var title: String
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text(title)
            Button("Change title") {
                title = "Hello"
            }
        }
        .font(.title3)
    }
}



// MARK: Constant + Closure
struct CustomBindingsExampleSecondChild: View {
    
    // MARK: - Properties
    
    let title: String
    
    let setTitle: (String) -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text(title)
            Button("Change title") {
                setTitle("Guten tag")
            }
        }
        .font(.title3)
    }
}



// MARK: Binding<> + $
// MARK: Binding<> + Binding(get:set:)
struct CustomBindingsExampleThirdChild: View {
    
    // MARK: - Properties
    
    let title: Binding<String>
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text(title.wrappedValue)
            Button("Change title") {
                title.wrappedValue = "Bonjour"
            }
        }
        .font(.title3)
    }
}



// MARK: Binding extension
extension Binding where Value == Bool {
    
    // Custom init for optional bindings
    init<T>(_ value: Binding<T?>) {
        self.init(
            get: { value.wrappedValue != nil },
            set: { if !$0 { value.wrappedValue = nil }}
        )
    }
}

// MARK: - Preview

#Preview {
    CustomBindingsExample()
}
