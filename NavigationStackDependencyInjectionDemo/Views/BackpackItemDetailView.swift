//
//  BackpackItemDetailView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/30/23.
//

import SwiftUI

struct BackpackItemDetailView: View {
    
    let item: String
    
    var body: some View {
        VStack {
            Text("Well would ya look at that!")
        }
        .basicNavigationBar(title: "\(item)")
    }
}

struct BackpackItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BackpackItemDetailView(item: "Flashlight")
    }
}
