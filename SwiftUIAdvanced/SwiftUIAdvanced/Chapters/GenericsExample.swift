//
//  GenericsExample.swift
//  SwiftUIAdvanced
//
//  Created by Wojciech Spaleniak on 11/11/2024.
//



// MARK: - NOTES

// MARK: 8 - How to use Generics in Swift
///
/// - ONLY CODE



// MARK: - CODE

import SwiftUI

struct GenericsExampleModel<T> {
    
    // MARK: - Properties
    
    let info: T?
    
    // MARK: - Methods
    
    func removeInfo() -> Self {
        .init(info: nil)
    }
}



final class GenericsExampleViewModel: ObservableObject {
    
    // MARK: - Preoperties
    
    @Published
    private(set) var stringModel = GenericsExampleModel<String>(info: "Hello world!")
    
    @Published
    private(set) var boolModel = GenericsExampleModel<Bool>(info: true)
    
    // MARK: - Methods
    
    func removeData() {
        stringModel = stringModel.removeInfo()
        boolModel = boolModel.removeInfo()
    }
}



struct GenericsExampleView<T: View>: View {
    
    // MARK: - Properties
    
    let content: T
    
    // MARK: - Body
    
    var body: some View {
        content
    }
}



struct GenericsExample: View {
    
    // MARK: - Properties
    
    @StateObject
    private var viewModel = GenericsExampleViewModel()
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Text(viewModel.stringModel.info ?? "no data")
            Text(viewModel.boolModel.info?.description ?? "no data")
            
            GenericsExampleView(content: Text("new view"))
        }
        .onTapGesture { viewModel.removeData() }
    }
}

// MARK: - Preview

#Preview {
    GenericsExample()
}
