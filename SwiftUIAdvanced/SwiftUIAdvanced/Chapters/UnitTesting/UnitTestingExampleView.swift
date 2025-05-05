//
//  UnitTestingExampleView.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 21/11/2024.
//



// MARK: - NOTES

// MARK: 17 - Unit Testing a SwiftUI application in Xcode
///
/// - `Unit Testing` jest dużo bardziej istotny niż `UI Testing`
/// - aby dodać nowe testy do projektu musimy dodać nowy `Target`
/// - klikamy `File > New > Target...` i wybieramy `Unit Testing Bundle` i klikamy `Finish`
/// - aby dodać nowe testy dla danego komponentu musimy dodać nowy plik testowy
/// - klikamy `File > New > File from Template...` i wybieramy `XCTest Unit Test`
///
/// - KONWENCJE NAZEWNICTWA:
/// - początek nazwy metody testującej powinien się zaczynać prefiksem `test` - inaczej kompilator nie rozpozna że jest to metoda testująca
/// - nazwa metody testującej powinna odzwiecierdlać to co rzeczywiście będzie testowane
/// - po słowie `test` dajemy informację o pliku jaki testujemy
/// - następnie co konkretnie testujemy w tym pliku np. metoda lub zmienna
/// - na końcu nazwy informujemy o tym jakiego rezultatu oczekujemy
/// - `func test_[struct or class]_[variable or method]_[expected result]()
/// - `func test_UnitTestingExampleViewModel_isPremium_shouldBeTrue()`
///
/// - STRUKTURA TESTÓW:
/// - logika wewnątrz każdej metody testującej składa się z 3 części: `Given, When, Then`
/// - `Given` - tutaj tworzymy wartości jakie będziemy przekazywać do testów
/// - `When` - tutaj wykonujemy testowaną logikę przy użyciu powyższych wartości
/// - `Then` - tutaj porównujemy otrzymany powyżej wynik z oczekiwanym rezultatem
///
/// - na górze w pliku testowym zaraz pod `import XCTest` należy zaimportować pliki danej aplikacji `@testable import SwiftUIAdvanced`
/// - robimy to aby pliki aplikacji były widoczne w targecie testów i możliwe do testowania
///
/// - NIEKTÓRE RODZAJE ASSERTÓW:
/// - `XCTAssertTrue` - czy przekazana wartość jest == true
/// - `XCTAssertFalse` - czy przekazana wartość jest == false
/// - `XCTAssertEqual` - czy przekazane wartości są ze sobą równe
/// - `XCTAssertNotEqual` - czy przekazywane wartości się od siebie różnią
/// - `XCTAssertNil` - czy przekazana wartość jest == nil
/// - `XCTAssertNotNil` - czy przekazana wartość jest != nil
/// - `XCTAssertThrowsError` - czy przekazana metoda rzuci błąd - ważne żeby metoda była poprzedzona słowem `try`
/// - `XCTAssertNoThrow` - czy przekazana metoda nie rzuci błędu
///
/// - w metodzie testującej możemy dodawać więcej niż jeden `Assert`
/// - aby testować metody asynchroniczne musimy użyć przed `Assert` metodę `wait(for:timeout:)` która pozwoli odczekać określony czas
/// - pierwszym argumentem jest `expectation: XCTestExpectation` na którym należy wywołać metodę `.fulfill` gdy dane się załadują - w tym celu możemy użyć nasłuchiwania na, w tym przypadku tablicę elementów z view modelu
/// - drugim argumentem jest maksymalny czas ile metoda ma czekać na zwrócenie danych - optymalnie jest to `5 sekund`
/// - gdy dodajemy w klasie testowej `cancellables` potrzebne do nasłuchiwania wartości w `Combine` to warto wywołać `cancellables.removeAll()` w metodzie kończącej każdy test tj. w `tearDownWithError()`



// MARK: - CODE

import SwiftUI

struct UnitTestingExampleView: View {
    
    // MARK: - Properties
    
    @StateObject
    private var viewModel: UnitTestingExampleViewModel
    
    // MARK: - Init
    
    init(isPremium: Bool) {
        _viewModel = StateObject(
            wrappedValue: UnitTestingExampleViewModel(isPremium: isPremium)
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        Text("Premium: \(viewModel.isPremium)")
    }
}

// MARK: - Preview

#Preview {
    UnitTestingExampleView(isPremium: true)
}
