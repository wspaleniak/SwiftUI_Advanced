//
//  AdvancedCombineExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 17/01/2025.
//



// MARK: - NOTES

// MARK: 19 - Advanced Combine Publishers and Subscribers in SwiftUI
///
/// - **@Published**
/// - najbardziej podstawowy publisher
/// - inicjalizujemy go za pomocą wrapperla >> `@Published var publisher: String = ""`
/// - aby wysłać nową wartość po prostu przypisujemy ją do zmiennej >> `publisher = "Nowa wartość"`
///
/// - **CurrentValueSubject**
/// - jest to to samo co `@Published` ale nie opakowane we wrapper
/// - inicjalizacja >> `let publisher = CurrentValueSubject<String, Never>("")`
/// - możemy podać `Never` lub `Error` w zależności od tego czy może rzucić błędem
/// - aby wysłać nową wartość używamy >> `publisher.send("Nowa wartość")`
///
/// - **PassthroughSubject**
/// - nie posiada początkowej wartości
/// - działa identycznie jak `CurrentValueSubject` ale nie przechowuje żadnej wartości
/// - inicjalizacja >> `let publisher = PassthroughSubject<String, Never>()`
/// - aby wysłać nową wartość używamy >> `publisher.send("Nowa wartość")`
///
/// - subskrybując powyższe publishery możemy manipulować danymi jakie z nich dostajemy
/// - poniżej niektóre z możliwości:
/// -
/// - **Sequence operations**
/// - `first()` - subskrybujemy tylko pierwszy element z publishera
/// - `first(where:)` - subskrybujemy tylko pierwszy element z publishera zgodny z warunkiem
/// - `tryFirst(where:)` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `last()` - subskrybujemy tylko ostatni element z publishera - ważne żeby publisher zakończył działanie bo inaczej nic nie zostanie przechwycone
/// - `last(where:)` - subskrybujemy tylko ostatni element z publishera zgodny z warunkiem - dostaniemy element dopiero jak publisher zakończy działanie
/// - `tryLast(where:)` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `dropFirst()` - pomija pierwszy element publishera - przydatne gdy posiadamy początkową wartość a nie chcemy żeby pojawiła się w streamie
/// - `dropFirst(count:)` - pomija określoną ilość pierwszych elementów publishera
/// - `drop(untilOutputFrom:)` - pomija elementy publishera dopóki podany w argumencie inny publisher nie otrzyma wartości
/// - `drop(while:)` - pomija elementy publishera dopóki warunek w closure zwraca true - gdy już raz zwróci false to przestaje pomijać i publikuje po kolei jak leci
/// - `tryDrop(while:)` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `prefix(maxLength:)` - subskrybujemy określoną liczbę pierwszych elementów z publishera
/// - `prefix(untilOutputFrom:)` - subskrybujemy pierwsze elementy publishera dopóki podany w argumencie inny publisher nie otrzyma wartości
/// - `prefix(while:)` - subskrybujemy pierwsze elementy publishera dopóki warunek w closure zwraca true - gdy zwróci false to przestaje publikować elementy
/// - `tryPrefix(while:)` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `output(at:)` - subskrybuje tylko element publishera który znajduje się na podanym indeksie
/// - `output(in:)` - subskrybuje tylko elementy publishera które znajdują się w podanym zakresie indeksów
/// -
/// - **Mathematic operations**
/// - `max()` - maksymalny element z publishera - dostaniemy element dopiero jak publisher zakończy działanie
/// - `max(by:)` - maksymalny element z publishera zgodny z kolejnością w domknięciu
/// - `tryMax(by:)` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `min()` - minimalny element z publishera - dostaniemy element dopiero jak publisher zakończy działanie
/// - `min(by:)` - minimalny element z publishera zgodny z kolejnością w domknięciu
/// - `tryMin(by:)` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// -
/// - **Filtering/Reducing operations**
/// - `map()` - modyfikujemy otrzymany typ w inny
/// - `tryMap()` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `compactMap()` - modyfikujemy otrzymany typ na inny - ale gdy zwrócimy nil dla wybranego elementu to zostanie on pominięty
/// - `tryCompactMap()` - to samo co powyżej ale dodatkowo domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `filter()` - pozostawia tylko elementy zgodne z warunkiem w domknięciu
/// - `tryFilter()` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `removeDuplicates()` - usuwa identyczne elementy - przydatne żeby np. nie odświeżać ekranu dwa razy gdy przyjdą takie same wartości jedna po drugiej
/// - `removeDuplicates(by:)` - to samo co powyżej - ale nie musimy porównywać całych obiektów tylko jakieś ich wybrane pola np. name lub age
/// - `tryRemoveDuplicates(by:)` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `replaceNil(with:)` - zastępuje wartości nil wartością określoną w argumencie
/// - `replaceEmpty(with:)` - zastępuje wartości będące pustą tablicą wartościami określonymi w argumencie
/// - `replaceError(with:)` - gdy wcześniejsza operacja rzuci błędem np. tryMap to zastąpimy to wybraną wartością zamiast obsługi błędu w `sink >> completion`
/// - `scan(initialResult:nextPartialResult:)` - ustawiamy wartość początkową i w domknięciu dostajemy dwa argumenty czyli istniejącą wartość oraz nową wartość z publishera - na samym początku istniejąca wartość to będzie ustawiona wartość początkowa - na poniższym przykładzie dodajemy sobie istniejącą wartość oraz nową wartość dlatego każdy kolejny element publikowany przez publisher jest sumą poprzedniej i nowej wartości - poprzednia wartość to 3 a kolejna to 5 więc dostaniemy wartość 8
/// - `tryScan(initialResult:nextPartialResult:)` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `reduce(initialResult:nextPartialResult:)` - działa podobnie jak scan ale z tą różnicą że czeka na zakończenie działania publishera i zwraca ostatnią wartość zamiast publikować sumy wartości po kolei
/// - `tryReduce(initialResult:nextPartialResult:)` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
/// - `collect()` - czeka na zakończenie działania publishera i publikuje jego wszystkie elementy jako tablicę
/// - `collect(count:)` - publikuje ilość elementów publishera określoną w argumencie - jeżeli publisher opublikuje 10 elementów a count jest ustawione na wartość 3 to najpierw dostaniemy 3 pierwsze elementy potem 3 kolejne, znowu 3 kolejne i tak dalej - dostajemy elementy z publishera partiami
/// - `allSatisfy()` - zwraca jedną wartość true lub false - sprawdza czy wszystkie elementy publikowane przez publisher są zgodne z warunkiem w domknięciu
/// - `tryAllSatisfy()` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
///
/// - **Timing operations**
/// - `debounce(for:scheduler:)` - poprzednia wartość zostanie pominięta jeśli nowa pojawiła się szybciej niż czas określony w argumencie
/// - `delay(for:scheduler:)` - opóźnia otrzymanie wartości z publishera o czas określony w argumencie
/// - `measureInterval(using:)` - zamiast elementów zwraca czas pomiędzy publikowanymi elementami - *$0.timeInterval*
/// - `throttle(for:scheduler:latest:)` - subskrybuje pierwszą wartość a następnie zamyka subskrybcję na określony w argumencie czas -  nie subskrybuje żadnej wartości która przyjdzie z publishera w tym czasie - latest określa czy na zakończenie działania publishera weźmie ostatni czy pierwszy otrzymany element podczas wstrzymania subskrybcji
/// - `retry(retries:)` - pozwala ponowić subskrybcję określoną w argumencie ilość razy - używane dla *URLSession*
/// - `timeout(interval:scheduler:)` - określa czas w którym musi przyjść nowy element z publishera - jeśli element przyjdzie później to nie zostanie odebrany a cała subskrypcja zostanie wstrzymana
///
/// - **Multiple Publishers / Subscribers**
/// - `combineLatest()` - pozwala połączyć subskrybcję elementów z dwóch lub więcej publisherów natomiast nadal jest to kilka streamów i z każdego dostajemy elementy - WAŻNE: jeżeli publishery są połączone w ten sposób to każdy z nich musi opublikować wartość żeby kod w `sink` się wywołał - używając *PassthroughSubject* kod wykona się dopiero gdy oba publishery wyślą wartość - używając *CurrentValueSubject* kod wykona się również na bieżących wartościach przechowywanych przez publishery
/// - `merge(with:)` - pozwala połaczyć subskrybcję elementów z dwóch lub więcej publisherów w jedną natomiast jest to jeden stream elementów i za jednym razem dostajemy elementy z dwóch lub więcej publisherów - WAŻNE: elementy publikowane przez mergowane publishery muszą mieć ten sam typ
/// - `zip()` - pozwala połaczyć subskrybcję elementów z dwóch lub więcej publisherów i jest to jeden stream z elementami połączonymi w tuples - publishery mogą publikować elementy różnych typów - WAŻNE: wszystkie zipowane publishery muszą publikować elementy i wtedy dalszy kod się wykona - czyli jeśli dwa pierwsze opublikowały elementy to zostaną one subskrybowane i przekazane dalej jako tuple dopiero gdy trzeci opublikuje pierwszą wartość
/// - `catch()` - jeśli publisher który jest subskrybowany rzuci błędem i zakończy działanie to możemy w tym miejscu zamienić go na inny publisher który dalej będzie publikował swoje elementy - dzięki temu nasłuchiwanie wartości będzie działało nadal - jednak będą to wartości z nowego publishera
/// - `tryCatch()` - to samo co powyżej ale domknięcie może rzucić błędem - błąd obsługujemy w `sink >> completion`
///
/// - aby zakończyć działanie publishera używamy `publisher.send(completion: .finished)`
/// - możemy również przekazać jako argument `.failure(error:)` i przekazać w nim błąd
/// - zakończenie publishera przechwytujemy w `sink > completion`
///
/// - jeśli chcemy subskrybować ten sam publisher ale kilka razy to powinniśmy stworzyć dla niego zmienną i wywołać na nim metodę `share()`
/// - kolejne odwołania do subskrybowania elementów z tego publishera powinny do odwoływać właśnie do tej zmiennej - jest to bardziej efektywne rozwiązanie



// MARK: - CODE

import Combine
import SwiftUI

final class AdvancedCombineExampleDataService {
    
    // MARK: - Properties
    
    // @Published private(set) var basicPublisher: Int = 0
    
    // let currentValuePublisher = CurrentValueSubject<Int, Never>(0)
    
    let passThroughPublisher = PassthroughSubject<Int, Never>()
    
    let boolPublisher = PassthroughSubject<Bool, Never>()
    
    let intPublisher = PassthroughSubject<Int, Never>()
    
    // MARK: - Init
    
    init() { publishData() }
    
    // MARK: - Methods
    
    private func publishData() {
        let items = Array(0..<11)
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) { [weak self] in
                guard let self else {
                    return
                }
                // basicPublisher = items[index]
                // currentValuePublisher.send(items[index])
                passThroughPublisher.send(items[index])
                
                if index > 4 && index < 8 {
                    boolPublisher.send(true)
                    intPublisher.send(999)
                } else {
                    boolPublisher.send(false)
                }
                
                if index == items.indices.last {
                    passThroughPublisher.send(completion: .finished)
                }
            }
        }
    }
}



final class AdvancedCombineExampleViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published
    private(set) var data: [String] = []
    
    @Published
    private(set) var boolData: [Bool] = []
    
    @Published
    private(set) var error: String = ""
    
    private let dataService = AdvancedCombineExampleDataService()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init() { addObservations() }
    
    // MARK: - Methods
    
    private func addObservations() {
        // dataService.passThroughPublisher
            /// **Sequence operations**
            // .first()
            // .first(where: { $0 > 2 })
            // .tryFirst(where: { value in
            //     if value == 3 { throw URLError(.unknown) }
            //     return value > 6
            // })
            // .last()
            // .last(where: { $0 < 4 })
            // .tryLast(where: { value in
            //     if value == 3 { throw URLError(.unknown) }
            //     return value < 6
            // })
            // .dropFirst()
            // .dropFirst(3)
            // .drop(while: { $0 > 6 })
            // .tryDrop(while: { value in
            //     if value == 3 { throw URLError(.unknown) }
            //     return value < 6
            // })
            // .prefix(4)
            // .prefix(while: { $0 < 5 })
            // .tryPrefix(while: { value in
            //     if value == 3 { throw URLError(.unknown) }
            //     return value < 6
            // })
            // .output(at: 4)
            // .output(in: 1..<5)
        
            /// **Mathematic operations**
            // .max()
            // .max(by: { $0 > $1 }) -> zwróci 0
            // .max(by: { $0 > $1 }) -> zwróci 10
            // .tryMax(by: { value1, value2 in ... })
            // .min()
            // .min(by: { $0 > $1 }) -> zwróci 10
            // .min(by: { $0 < $1 }) -> zwróci 0
            // .tryMin(by: { value1, value2 in ... })
        
            /// **Filtering/Reducing operations**
            // .map { String($0) }
            // .tryMap { value in
            //     if value == 3 { throw URLError(.unknown) }
            //     return String(value)
            // }
            // .compactMap { value in
            //     if value == 3 { return nil }
            //     return String(value)
            // }
            // .tryCompactMap { value in
            //     if value == 3 { return nil }
            //     if value == 6 { throw URLError(.unknown) }
            //     return String(value)
            // }
            // .filter { $0.isMultiple(of: 2) }
            // .tryFilter { value in
            //     if value == 6 { throw URLError(.unknown) }
            //     return value.isMultiple(of: 2)
            // }
            // .removeDuplicates()
            // .removeDuplicates(by: { $0 == $1 })
            // .tryRemoveDuplicates(by: { value1, value2 in ... })
            // .replaceNil(with: 99)
            // .replaceEmpty(with: [])
            // .replaceError(with: 99)
            // .scan(0) { existingValue, newValue in
            //     return existingValue + newValue
            // }
            // .scan(0, { $0 + $1 })
            // .scan(0, +)
            // .tryScan(0) { existingValue, newValue in
            //     if newValue == 6 { throw URLError(.unknown) }
            //     return existingValue + newValue
            // }
            // .reduce(0) { existingValue, newValue in
            //     return existingValue + newValue
            // }
            // .reduce(0, { $0 + $1 })
            // .reduce(0, +)
            // .tryReduce(0) { existingValue, newValue in
            //     if newValue == 6 { throw URLError(.unknown) }
            //     return existingValue + newValue
            // }
            // .collect()
            // .collect(3)
            // .allSatisfy { $0 < 3 }
            // .tryAllSatisfy { value in
            //     if value == 3 { throw URLError(.unknown) }
            //     return value < 6
            // }
        
            /// **Timing operations**
            // .debounce(for: 0.75, scheduler: DispatchQueue.main)
            // .delay(for: 2.0, scheduler: DispatchQueue.main)
            // .measureInterval(using: DispatchQueue.main)
            // .throttle(for: 11.0, scheduler: DispatchQueue.main, latest: true)
            // .retry(3)
            // .timeout(0.75, scheduler: DispatchQueue.main)
        
            /// **Multiple Publishers / Subscribers**
            // CombineLatest:
            // >>1<<
            // .combineLatest(dataService.boolPublisher)
            // .compactMap { $1 ? $0 : nil }
            // .removeDuplicates()
            // >>2<<
            // .combineLatest(dataService.boolPublisher, dataService.intPublisher)
            // .compactMap { intValue, boolValue, _  in
            //     return boolValue ? intValue : -1
            // }
            //
            // Merge:
            // .merge(with: dataService.intPublisher)
            //
            // Zip:
            // .zip(dataService.boolPublisher, dataService.intPublisher)
            // .map { tuple in
            //     "\(tuple.0): \(tuple.1): \(tuple.2)"
            // }
            //
            // Catch:
            // .tryMap { value in
            //     if value == 6 { throw URLError(.unknown) }
            //     return value
            // }
            // .catch { error in
            //     self.dataService.intPublisher
            // }
            // .tryCatch { error in ... }
        
        let sharedPublisher = dataService.passThroughPublisher
            .dropFirst(3)
            .share()
        
        sharedPublisher
            .map { String($0) }
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = "ERROR: \(error)"
                }
            } receiveValue: { [weak self] returnedValue in
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)
        
        sharedPublisher
            .map { $0 > 4 && $0 < 8 }
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = "ERROR: \(error)"
                }
            } receiveValue: { [weak self] returnedValue in
                self?.boolData.append(returnedValue)
            }
            .store(in: &cancellables)
    }
}



struct AdvancedCombineExample: View {
    
    // MARK: - Properties
    
    @StateObject
    private var viewModel = AdvancedCombineExampleViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    ForEach(viewModel.data, id: \.self) { item in
                        Text(item)
                            .font(.largeTitle.bold())
                    }
                    if !viewModel.error.isEmpty {
                        Text(viewModel.error)
                    }
                }
                Spacer()
                VStack {
                    ForEach(viewModel.boolData, id: \.self) { item in
                        Text(item.description)
                            .font(.largeTitle.bold())
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Preview

#Preview {
    AdvancedCombineExample()
}
