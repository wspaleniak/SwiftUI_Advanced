//
//  UITestingExampleView.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 15/01/2025.
//



// MARK: - NOTES

// MARK: 18 - UI Testing a SwiftUI application in Xcode
///
/// - aby dodać nowe testy ui do projektu musimy dodać nowy `Target`
/// - klikamy `File > New > Target...` i wybieramy `UI Testing Bundle` i klikamy `Finish`
/// - aby dodać nowe testy dla danego komponentu musimy dodać nowy plik testowy
/// - klikamy `File > New > File from Template...` i wybieramy `XCTest UI Test`
///
/// - w metodzie `setUpWithError()` warto zostawić ustawienie `continueAfterFailure = false`
/// - oznacza to że jeżeli jeden z testów się wywali to nie próbuj testować kolejnych
/// 
/// - KONWENCJE NAZEWNICTWA:
/// - `func test_[struct]_[ui component]_[expected result]()
/// - `func test_UITestingExampleView_signUpButton_shoulSignIn()`
///
/// - PISANIE TESTU
/// - możemy w kodzie wygenerować co ma się klikać w aplikacji na widoku który testujemy
/// - klikamy w ciało metody testującej i klikamy czerwony przycisk `record` na samym dole z lewej strony
/// - po kliknięciu odpali sie aplikacja na symulatorze i możemy klikać w elementy na widoku
/// - po kliknięciu w dany element będzie nam się generował kod w ciele metody testującej który mówi o tym że dany element został kliknięty
/// - np. kliknięcie przycisku `Sign Up` wygląda tak `app.buttons["Sign Up"].tap()`
///
/// - OZNACZANIE ELEMENTÓW UI DO TESTÓW
/// - aby móc się odnieść do elementu z widoku w testach należy dodać identyfikator
/// - robimy to za pomocą modyfikatora `.accessibilityIdentifier("NameTextField")`
/// - wtedy odniesienie do elementu wygląda tak `app.textFields["NameTextField"]`
///
/// - UWAGA
/// - jak jest jakaś animacja to trzeba dać `sleep(1)` bo inaczej element może być jeszcze niewidoczny dla testu
/// - np. jak robimy przejście z ekranu na ekran lub pokazujemy alert
/// - ALE zamiast tego możemy również użyć metody która czeka na pojawienie się danego elementu z maksymalnym czasem oczekiwania
/// - aby jej użyć wywołujemy na danym elemencie `let alertExists = alert.waitForExistence(timeout: 5.0)`
/// - na zwrocie z metody dostajemy flagę czy obiekt się pojawił w wyznaczonym czasie czy nie
/// - to samo gdy czekamy na zniknięcie elementu `let alertNotExists = alert.waitForNonExistence(timeout: 5.0)`
///
/// - DEPENDENCY INJECTION W UI TESTACH
/// - w testach UI ważne jest wstrzykiwanie zależności do widoków
/// - dla przykładu aplikacja może startować jako zalogowana lub niezalogowana
/// - argument o zalogowaniu usera możemy przekazać `Górny pasek > Edit Scheme... > Run > Arguments > Arguments Passed On Launch`
/// - tam sobie dodajemy nazwę argumentu np. `~UITest_startSignedIn` i zaznaczamy czy jest przekazywany na starcie czy nie
/// - aby sprawdzić w kodzie czy argument jest przekazywany na starcie używamy `CommandLine.arguments.contains("~UITest_startSignedIn")`
/// - lub za pomocą `ProcessInfo.processInfo.arguments.contains("~UITest_startSignedIn")` - obie opcje dostępu są poprawne
/// - lub
/// - możemy też przekazywać argumenty jako Environment z nadaną już wartością
/// - robimy to za pomocą `Górny pasek > Edit Scheme... > Run > Arguments > Environment Variables`
/// - tam również dodajemy nazwę argumentu np. `~UITest_startSignedIn` oraz jego wartość która zawsze jest typu `String`
/// - tutaj również możemy zaznaczyć czy argument jest przekazywany na starcie czy nie
/// - aby sprawdzić w kodzie czy argument jest przekazywany na starcie używamy `ProcessInfo.processInfo.environment["~UITest_startSignedIn"]`
/// - oraz
/// - `Argument` lub `Environment` w testach przekazujemy  w metodzie `setUpWithError` przed wywołaniem `app.launch()`
/// - wygląda to następująco `app.launchArguments = ["~UITest_startSignedIn"]`
/// - lub `app.launchEnvironment = ["~UITest_startSignedIn": "true"]`



// MARK: - CODE

import SwiftUI

struct UITestingExampleView: View {
    
    // MARK: - Properties
    
    @StateObject
    private var viewModel: UITestingExampleViewModel
    
    // MARK: - Init
    
    init(isSignedIn: Bool) {
        _viewModel = StateObject(
            wrappedValue: UITestingExampleViewModel(
                isSignedIn: isSignedIn
            )
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if viewModel.isSignedIn {
                UITestingExampleHomeView()
                    .environmentObject(viewModel)
                    .transition(.move(edge: .bottom))
            } else {
                signUpSection
                    .transition(.move(edge: .top))
            }
        }
        .animation(.smooth, value: viewModel.isSignedIn)
    }
    
    // MARK: - Subviews
    
    private var signUpSection: some View {
        VStack {
            signUpForm
            signUpButton
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var signUpForm: some View {
        TextField(viewModel.namePlaceholder, text: $viewModel.nameText)
            .font(.headline)
            .padding()
            .background(
                Capsule().fill(.gray.opacity(0.15))
            )
            .accessibilityIdentifier("NameTextField")
    }
    
    private var signUpButton: some View {
        Button {
            viewModel.signUp()
        } label: {
            Text("Sign Up")
                .frame(maxWidth: .infinity)
                .font(.headline)
                .padding()
                .foregroundStyle(.white)
                .background(
                    Capsule().fill(.blue)
                )
        }
        .accessibilityIdentifier("SignUpButton")
    }
}

// MARK: - Preview

#Preview {
    UITestingExampleView(
        isSignedIn: false
    )
}
