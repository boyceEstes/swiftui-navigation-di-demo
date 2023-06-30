//
//  RiverView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI

// Requires some sort of dependency
struct RiverView: View {
    
    let backpackRepository: BackpackRepository
    let goToBridge: () -> Void
    let goToFishing: () -> Void
    
    var body: some View {
        VStack {
            Text("You see gently rolling waters sparkling under the sun")
            Button("Walk to Bridge") {
                goToBridge()
            }
            .buttonStyle(BigDealButtonStyle(backgroundColor: .red))
            
            Button("Cast a Line") {
                goToFishing()
            }
            .buttonStyle(BigDealButtonStyle(backgroundColor: .orange))
        }
        .basicNavigationBar(title: "River")
    }
}

struct RiverView_Previews: PreviewProvider {
    static var previews: some View {
        RiverView(backpackRepository: BackpackRepository.preview, goToBridge: { }, goToFishing: { } )
    }
}
