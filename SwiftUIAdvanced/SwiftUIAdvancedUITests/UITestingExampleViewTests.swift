//
//  UITestingExampleViewTests.swift
//  SwiftUIAdvancedUITests
//
//  Created by Wojciech Spaleniak on 15/01/2025.
//



// MARK: - NOTES

// MARK: 18 - UI Testing a SwiftUI application in Xcode
///
/// - ONLY CODE



// MARK: - CODE

import XCTest

final class UITestingExampleViewTests: XCTestCase {
    
    // MARK: - Properties
    
    var app: XCUIApplication?
    
    // MARK: - Overrides

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        app = XCUIApplication()
        app?.launchArguments = ["~UITest_startSignedIn"]
        // app?.launchEnvironment = ["~UITest_startSignedIn": "true"]
        app?.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    
    // MARK: - Methods
    
    func test_UITestingExampleView_signUpButton_shouldNotSignIn() {
        // Given
        guard let app, !isSignIn else {
            return
        }
        // When
        signIn(false)
        let navigationBar = app.navigationBars["Welcome"]
        let navigationBarExists = navigationBar.waitForExistence(timeout: 5.0)
        // Then
        XCTAssertFalse(navigationBarExists)
    }
    
    func test_UITestingExampleView_signUpButton_shoulSignIn() {
        // Given
        guard let app, !isSignIn else {
            return
        }
        // When
        signIn(true)
        let navigationBar = app.navigationBars["Welcome"]
        let navigationBarExists = navigationBar.waitForExistence(timeout: 5.0)
        // Then
        XCTAssertTrue(navigationBarExists)
    }
    
    func test_UITestingExampleHomeView_showAlertButton_shouldShowAlert() {
        // Given
        guard let app else {
            return
        }
        // When
        signIn(true)
        showAlert(dismiss: false)
        let alert = app.alerts.firstMatch
        let alertExists = alert.waitForExistence(timeout: 5.0)
        // Then
        XCTAssertTrue(alertExists)
    }
    
    func test_UITestingExampleHomeView_showAlertButton_shouldShowAndDismissAlert() {
        // Given
        guard let app else {
            return
        }
        // When
        signIn(true)
        showAlert(dismiss: true)
        let alert = app.alerts.firstMatch
        let alertNotExists = alert.waitForNonExistence(timeout: 5.0)
        // Then
        XCTAssertTrue(alertNotExists)
    }
    
    func test_UITestingExampleHomeView_navigationLinkButton_shouldNavigateToDestination() {
        // Given
        guard let app else {
            return
        }
        // When
        signIn(true)
        navigateToDestination(back: false)
        let destinationText = app.staticTexts["Destination"]
        let destinationTextExists = destinationText.waitForExistence(timeout: 5.0)
        // Then
        XCTAssertTrue(destinationTextExists)
    }
    
    func test_UITestingExampleHomeView_navigationLinkButton_shouldNavigateToDestinationAndGoBack() {
        // Given
        guard let app else {
            return
        }
        // When
        signIn(true)
        navigateToDestination(back: true)
        let destinationText = app.staticTexts["Destination"]
        let destinationTextNotExists = destinationText.waitForNonExistence(timeout: 5.0)
        // Then
        XCTAssertTrue(destinationTextNotExists)
    }
}

// MARK: - Helpers

extension UITestingExampleViewTests {
    
    /// Czy użytkownik jest zalogowany w aplikacji.
    private var isSignIn: Bool {
        guard let app else {
            return false
        }
        return app.launchArguments.contains("~UITest_startSignedIn")
    }
    
    /// Metoda pozwala się zalogować ze skutkiem przewidzianym w argumencie.
    private func signIn(_ success: Bool) {
        guard let app, !isSignIn else {
            return
        }
        let textField = app.textFields["NameTextField"]
        textField.tap()
        if success {
            let keyBigA = app.keys["A"]
            keyBigA.tap()
            let keySmallA = app.keys["a"]
            keySmallA.tap()
            keySmallA.tap()
        }
        let returnButton = app.buttons["Return"]
        returnButton.tap()
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
    }
    
    /// Metoda pozwala pokazać alert.
    private func showAlert(dismiss: Bool) {
        guard let app else {
            return
        }
        let showAlertButton = app.buttons["ShowAlertButton"]
        let showAlertButtonExists = showAlertButton.waitForExistence(timeout: 5.0)
        XCTAssertTrue(showAlertButtonExists)
        showAlertButton.tap()
        if dismiss {
            let alert = app.alerts.firstMatch
            let alertExists = alert.waitForExistence(timeout: 5.0)
            XCTAssertTrue(alertExists)
            let alertOkButton = alert.scrollViews.otherElements.buttons["OK"]
            alertOkButton.tap()
        }
    }
    
    /// Metoda pozwala przejść do widoku "Destination".
    private func navigateToDestination(back: Bool) {
        guard let app else {
            return
        }
        let navigationLinkButton = app.buttons["NavigationLinkButton"]
        let navigationLinkButtonExists = navigationLinkButton.waitForExistence(timeout: 5.0)
        XCTAssertTrue(navigationLinkButtonExists)
        navigationLinkButton.tap()
        if back {
            let destinationText = app.staticTexts["Destination"]
            let destinationTextExists = destinationText.waitForExistence(timeout: 5.0)
            XCTAssertTrue(destinationTextExists)
            let destinationBackButton = app.navigationBars.buttons["Welcome"]
            destinationBackButton.tap()
        }
    }
}
