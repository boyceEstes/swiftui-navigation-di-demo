//
//  BackpackListView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 7/3/23.
//

import SwiftUI





struct BackpackListView: View {
    
    let backpackRepository: BackpackRepository
    let goToBackpackItemDetail: (String) -> Void
    
    @State private var items: [String] {
        didSet {
            print("items was set from somewhere: \(items)")
        }
    }
    
    
    init(
        backpackRepository: BackpackRepository,
        goToBackpackItemDetail: @escaping (String) -> Void
    ) {
        
        self.backpackRepository = backpackRepository
        self.goToBackpackItemDetail = goToBackpackItemDetail
        
        self.items = backpackRepository.getItems()
    }
    
    
    var body: some View {
        List {
            Section {
                ForEach(backpackRepository.getItems(), id: \.self) { item in
                    Button("\(item)") {
                        goToBackpackItemDetail(item)
                    }
                }
            } header: {
                Text("Backpack Contents")
            } footer: {
                if backpackRepository.getItems().isEmpty {
                    Text("Nothin in the backpack")
                }
            }
        }
        .basicNavigationBar(title: "Backpack", navigationBarColor: .green)
        .refreshable {
            items = backpackRepository.getItems()
        }
    }
}


struct BackpackListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BackpackListView(backpackRepository: .preview, goToBackpackItemDetail: { _ in })
        }
    }
}
