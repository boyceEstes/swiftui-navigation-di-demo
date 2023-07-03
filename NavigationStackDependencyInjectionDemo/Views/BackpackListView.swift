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
            ForEach(backpackRepository.getItems(), id: \.self) { item in
                Text("\(item)")
            }
        }
    }
}

struct BackpackListView_Previews: PreviewProvider {
    static var previews: some View {
        BackpackListView(backpackRepository: .preview)
    }
}
