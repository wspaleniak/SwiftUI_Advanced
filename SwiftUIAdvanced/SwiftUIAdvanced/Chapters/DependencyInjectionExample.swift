//
//  DependencyInjectionExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 21/11/2024.
//



// MARK: - NOTES

// MARK: 16 - How to use Dependency Injection in SwiftUI
///
/// - jeśli mamy w klasie lub strukturze jakieś zależności to zamiast inicjalizować je wewnątrz klasy lub struktury, zainicjalizujmy je poza nią i wstrzyknijmy w metodzie init
/// - dzięki temu klasa lub struktura będzie łatwiejsza do testowania ponieważ żależności będzie można zmockować
/// - dobrze też żeby wstrzykiwane typy były zgodne z konkretnym protokołem - wtedy mockowanie będzie prostsze
///
/// - Problemy z używaniem wzorca `Singleton`:
/// - jest to zmienna globalna która może być używana w każdej części kodu
/// - nie możemy customizować metody init
/// - nie możemy mockować zależności



// MARK: - CODE

import Combine
import SwiftUI

struct DependencyInjectionExampleModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}



protocol DependencyInjectionExampleServiceProtocol {
    func getData() -> AnyPublisher<[DependencyInjectionExampleModel], Never>?
}



final class DependencyInjectionExampleDataService: DependencyInjectionExampleServiceProtocol {
    
    // MARK: - Methods
    
    func getData() -> AnyPublisher<[DependencyInjectionExampleModel], Never>? {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return nil
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [DependencyInjectionExampleModel].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}



final class DependencyInjectionExampleMockDataService: DependencyInjectionExampleServiceProtocol {
    
    // MARK: - Methods
    
    func getData() -> AnyPublisher<[DependencyInjectionExampleModel], Never>? {
        let mockData: [DependencyInjectionExampleModel] = [
            .init(userId: 1, id: 1, title: "One", body: "one"),
            .init(userId: 2, id: 2, title: "Two", body: "two")
        ]
        return Just(mockData).eraseToAnyPublisher()
    }
}



final class DependencyInjectionExampleViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published
    private(set) var data: [DependencyInjectionExampleModel] = []
    
    let dataService: DependencyInjectionExampleServiceProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(dataService: DependencyInjectionExampleServiceProtocol) {
        self.dataService = dataService
        loadData()
    }
    
    // MARK: - Methods
    
    private func loadData() {
        dataService.getData()?
            .assign(to: \.data, on: self)
            .store(in: &cancellables)
    }
}



struct DependencyInjectionExample: View {
    
    // MARK: - Properties
    
    @StateObject
    private var viewModel: DependencyInjectionExampleViewModel
    
    // MARK: - Init
    
    init(dataService: DependencyInjectionExampleServiceProtocol) {
        _viewModel = StateObject(
            wrappedValue: DependencyInjectionExampleViewModel(
                dataService: dataService
            )
        )
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.data) { item in
                    Text(item.id.description)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    DependencyInjectionExample(
        dataService: DependencyInjectionExampleDataService()
        // dataService: DependencyInjectionExampleMockDataService() // MOCK
    )
}
