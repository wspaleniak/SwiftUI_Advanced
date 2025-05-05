//
//  UIViewRepresentableExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 18/11/2024.
//



// MARK: - NOTES

// MARK: 13 - Use UIViewRepresentable to convert UIKit views to SwiftUI
///
/// - `UIViewRepresentable` to wrapper który pozwala umieszczać widoki napisane w UIKit w widokach napisanych w SwiftUI
/// - w tym celu tworzymy strukturę zgodną z protokołem `UIViewRepresentable`
/// - implementujemy metodę `makeUIView(...)` którą tworzymy obiekt w `UIKit`
/// - implementujemy metodę `updateUIView(...)` którą komunikujemy się w kierunku: `SwiftUI -> UIKit` czyli informacje z widoku w `SwiftUI` możemy przekazywać do utworzonego w `UIKit` komponentu
/// - implementujemy metodę `makeCoordinator()` oraz tworzymy wewnątrz struktury klasę koordynatora `class Coordinator`
/// - utworzona klasa jest jednocześnie typem zwracanym przez metodę `makeCoordinator`
/// - koordynator odpowiada za komunikację w kierunku `UIKit -> SwiftUI` czyli informacje z komponentu `UIKit` możemy przekazywać do widoku w `SwiftUI`



// MARK: - CODE

import SwiftUI

struct UITextFieldViewRepresentable: UIViewRepresentable {
    
    // MARK: - Classes
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        // MARK: - Properties
        
        @Binding
        var text: String
        
        // MARK: - Init
        
        init(text: Binding<String>) {
            _text = text
        }
        
        // MARK: - Methods
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    // MARK: - Properties
    
    @Binding
    var text: String
    
    var placeholder: String
    
    let placeholderColor: UIColor
    
    // MARK: - Init
    
    init(text: Binding<String>, placeholder: String = "Default...", placeholderColor: UIColor = .red) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    // MARK: - Methods
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: placeholderColor]
        )
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    // Ta metoda pozwala aktualizować w widoku SwiftUI elementy komponentu UIKit
    func updatePlaceholder(_ text: String) -> Self {
        var viewRepresentable = self
        viewRepresentable.placeholder =  text
        return viewRepresentable
    }
}



struct UIViewRepresentableExample: View {
    
    // MARK: - Properties
    
    @State
    private var text: String = ""
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text(text)
            
            TextField("Type here...", text: $text)
                .padding()
                .frame(height: 50)
                .background(Capsule().fill(.gray.opacity(0.1)))
            
            UITextFieldViewRepresentable(text: $text)
                .updatePlaceholder("New placeholder...")
                .padding()
                .frame(height: 50)
                .background(Capsule().fill(.gray.opacity(0.1)))
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    UIViewRepresentableExample()
}
