//
//  FishDetailView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/30/23.
//

import SwiftUI

struct FishDetailView: View {
    
    let fish: String
    
    var body: some View {
        
        VStack {
            Text("Oy would you look at the size of that thing")
        }
        .basicNavigationBar(title: "\(fish)", navigationBarColor: .orange)
    }
}

struct FishDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FishDetailView(fish: "Snapper")
    }
}
