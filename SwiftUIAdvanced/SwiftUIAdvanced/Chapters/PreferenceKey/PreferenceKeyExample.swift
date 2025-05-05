//
//  PreferenceKeyExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 15/11/2024.
//



// MARK: - NOTES

// MARK: 10 - Use PreferenceKey to extract values from child views in SwiftUI / PART 1
///
/// - `PreferenceKey` pozwala przekazywać wartości z widoku dziecka do widoku rodzica
/// - aby utworzyć nowy `PreferenceKey` tworzymy strukturę zgodną z protokołem `PreferenceKey`
/// - oraz implementujemy w niej zmienną typu np. String `defaultValue: String`
/// - a także metodę `reduce(value:nextValue) -> String` zwracającą typ który otrzymała zmienna `defaultValue`
/// - w widoku rodzica dodajemy modyfikator `onPreferenceChange(key:action:)` gdzie kluczem jest nazwa utworzonego `PreferenceKey` natomiast akcja jest domknięciem które dostarcza nam w argumencie nową wartość z widoku dziecka i implementuje co ma się zadziać w widoku rodzica gdy pojawi się nowa wartość
/// - w widoku dziecka używamy modyfikatora `.preference(key:value:)` aby przekazywać nowe wartości do widoku rodzica



// MARK: - CODE

import SwiftUI

struct CustomTitlePreferenceKey: PreferenceKey {
    
    // MARK: - Properties
    
    static var defaultValue: String = ""
    
    // MARK: - Methods
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}



extension View {
    
    // MARK: - Methods
    
    func customTitle(_ title: String) -> some View {
        preference(key: CustomTitlePreferenceKey.self, value: title)
    }
}



struct PreferenceKeyExample: View {
    
    // MARK: Properties
    
    @State
    private var text: String = "Hello world!"
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            PreferenceKeyExampleChildView(text: text)
                .navigationTitle("Title")
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
            text = value
        }
    }
}



struct PreferenceKeyExampleChildView: View {
    
    // MARK: - Properties
    
    @State
    private var newValue: String = "..."
    
    let text: String
    
    // MARK: - Body
    
    var body: some View {
        Text(text)
            .customTitle(newValue)
            .onAppear(perform: getData)
    }
    
    // MARK: - Methods
    
    private func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            newValue = "DOWNLOADED VALUE"
        }
    }
}

// MARK: - Preview

#Preview {
    PreferenceKeyExample()
}
