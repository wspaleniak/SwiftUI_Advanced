//
//  CustomErrorsAndAlertsExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 02/02/2025.
//



// MARK: - NOTES

// MARK: 28 - Custom Errors and Alerts in SwiftUI
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

// MARK: - Protocol for alert in entire app
protocol AppAlert {
    associatedtype T: View
    var title: String { get }
    var subtitle: String? { get }
    var buttons: T { get }
}



// MARK: - Main view
struct CustomErrorsAndAlertsExample: View {
    
    // MARK: - Enums
    
    // MARK: Custom error
    // enum ErrorType: Error, LocalizedError {
    //     case noConnection
    //     case dataNotFound
    //     case urlError(Error)
    //     case unknown
    //
    //     var errorDescription: String? {
    //         switch self {
    //         case .noConnection: "Wystąpił błąd połączenia z internetem"
    //         case .dataNotFound: "Wystąpił błąd podczas ładowania danych"
    //         case .urlError(let error): "Wystąpił błąd: \(error.localizedDescription)"
    //         case .unknown: nil
    //         }
    //     }
    // }
    
    // MARK: Custom alert
    enum CustomAlert: AppAlert {
        case noConnection(action: () -> Void)
        case dataNotFound
        case urlError(error: Error)
        case unknown
        
        var title: String {
            switch self {
            case .noConnection: "Brak internetu"
            case .dataNotFound: "Brak danych"
            case .urlError: "Błąd"
            case .unknown: "Nieznany błąd"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .noConnection: "Wystąpił błąd połączenia z internetem"
            case .dataNotFound: "Wystąpił błąd podczas ładowania danych"
            case .urlError(let error): "Wystąpił błąd: \(error.localizedDescription)"
            case .unknown: nil
            }
        }
        
        @ViewBuilder
        var buttons: some View {
            switch self {
            case .noConnection(let action):
                Button("Retry") { action() }
            case .dataNotFound:
                Button("Retry now") { }
            case .urlError:
                Button("OK") { }
                Button("Delete", role: .destructive) { }
            case .unknown:
                Button("OK") { }
            }
        }
    }
    
    // MARK: - Properties
    
    @State
    private var alertType: CustomAlert? = nil
    
    // MARK: - Body
    
    var body: some View {
        Button("Show error alert") {
            showAlert()
        }
        .showCustomAlert($alertType)
    }
    
    // MARK: - Methods
    
    private func showAlert() {
        alertType = .noConnection(action: { print("retry tapped") })
        // alertType = .dataNotFound
        // alertType = .urlError(error: URLError(.badURL))
        // alertType = .unknown
    }
}



// MARK: - Extension for alert
extension View {
    
    func showCustomAlert<T: AppAlert>(_ type: Binding<T?>) -> some View {
        alert(
            type.wrappedValue?.title ?? "",
            isPresented: Binding(type),
            actions: { type.wrappedValue?.buttons },
            message: {
                if let subtitle = type.wrappedValue?.subtitle {
                    Text(subtitle)
                }
            }
        )
    }
}

// MARK: - Preview

#Preview {
    CustomErrorsAndAlertsExample()
}
