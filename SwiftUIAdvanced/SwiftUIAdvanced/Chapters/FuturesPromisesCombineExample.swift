//
//  FuturesPromisesCombineExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 30/01/2025.
//



// MARK: - NOTES

// MARK: 20 - How to use Futures and Promises in Combine with SwiftUI
///
/// - obiekt `Future` pozwala przekształcić kod napisany z wykorzystaniem `@escaping closure` na `Combine`
/// - w momencie gdy `@escaping closure` zwraca wartość poprzez domknięcie to wtedy `Future` publikuje tą wartość jako publisher
/// - `Future` jest publisherem który publikuje tylko jedną wartość i kończy swoje działanie
/// - tworząc obiekt `Future` dostajemy w argumencie domknięcia `promise` który też jest domknięciem i służy do opakowania wartości otrzymanej z `@escaping closure`
/// - możemy zwrócić `promise(.success(<wartość z closure>))` lub `promise(.failure(<error z closure>))`
/// - jeśli `Future` może zwrócić `promise(.failure(...))` to będzie to typ np. `Future<String, Error>`
/// - jednak w wypadku gdy zawsze zwraca `promise(.success(...))` to będzie to typ np. `Future<String, Never>`



// MARK: - CODE

import Combine
import SwiftUI

final class FuturesPromisesCombineExampleViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published
    var title: String = "Starting title"
    
    private let url = URL(string: "https://www.google.com")!
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init() { download() }
    
    // MARK: - Methods
    
    private func download() {
        // MARK: COMBINE
        // getCombinePublisher()
        //     .sink { completion in
        //         switch completion {
        //         case .finished:
        //             break
        //         case .failure(let error):
        //             print(error.localizedDescription)
        //         }
        //     } receiveValue: { returnedValue in
        //         self.title = returnedValue
        //     }
        //     .store(in: &cancellables)
        
        // MARK: ESCAPING CLOSURE
        // getEscapingClosure { [weak self] returnedValue, error in
        //     self?.title = returnedValue
        // }
        
        // MARK: FUTURE FROM ESCAPING CLOSURE
        // getFuturePublisher()
        //     .sink { completion in
        //         switch completion {
        //         case .finished:
        //             break
        //         case .failure(let error):
        //             print(error.localizedDescription)
        //         }
        //     } receiveValue: { [weak self] returnedValue in
        //         self?.title = returnedValue
        //     }
        //     .store(in: &cancellables)

        // MARK: FUTURE FROM ESCAPING CLOSURE
        doSomethingFuturePublisher()
            .assign(to: \.title, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: COMBINE
    private func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1.0, scheduler: DispatchQueue.main)
            .map { _ in "Combine value" }
            .eraseToAnyPublisher()
    }
    
    // MARK: ESCAPING CLOSURE
    private func getEscapingClosure(completion: @escaping (String, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { _, _, error in
            completion("Escaping closure value", error)
        }
        .resume()
    }
    
    // MARK: FUTURE FROM ESCAPING CLOSURE
    private func getFuturePublisher() -> Future<String, Error> {
        Future { [weak self] promise in
            self?.getEscapingClosure { returnedValue, error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(returnedValue))
                }
            }
        }
    }
    
    // MARK: ESCAPING CLOSURE
    private func doSomething(completion: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            completion("DO SOMETHING")
        }
    }
    
    // MARK: FUTURE FROM ESCAPING CLOSURE
    private func doSomethingFuturePublisher() -> Future<String, Never> {
        Future { [weak self] promise in
            self?.doSomething { returnedValue in
                promise(.success(returnedValue))
            }
        }
    }
}



struct FuturesPromisesCombineExample: View {
    
    // MARK: - Properties
    
    @StateObject
    private var viewModel = FuturesPromisesCombineExampleViewModel()
    
    // MARK: - Body
    
    var body: some View {
        Text(viewModel.title)
    }
}

// MARK: - Preview

#Preview {
    FuturesPromisesCombineExample()
}
