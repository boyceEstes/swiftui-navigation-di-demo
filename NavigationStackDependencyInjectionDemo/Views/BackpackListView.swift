//
//  BackpackListView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 7/3/23.
//

import SwiftUI



struct BackpackListView: View {
    
    let backpackRepository: BackpackRepository
    
    var body: some View {
        List {
            Section {
                ForEach(backpackRepository.getItems(), id: \.self) { item in
                    Text("\(item)")
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
    }
}

struct BackpackListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BackpackListView(backpackRepository: .preview)
        }
    }
}
