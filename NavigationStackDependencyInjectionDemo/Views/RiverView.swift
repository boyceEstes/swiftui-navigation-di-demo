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
    let goToFishing: (@escaping ([String]) -> Void) -> Void
    
    @State private var fishCaught = [String]()
    
    var body: some View {
        
        VStack {
            Text("You see gently rolling waters sparkling under the sun")
            Text("There is a stone walkway passing over the river")
            Button("Walk to Bridge") {
                goToBridge()
            }
            .buttonStyle(BigDealButtonStyle(backgroundColor: .red))
            
            Button("Cast a Line") {
                print("Go to fishing")
                goToFishing( { caughtFish in print("Hello world - from river view, retrieved: \(caughtFish)")
                    fishCaught = caughtFish
                })
            }
            .buttonStyle(BigDealButtonStyle(backgroundColor: .orange))
            
            List(fishCaught, id: \.self) { fish in
                Text("\(fish)")
            }
        }
        .basicNavigationBar(title: "River")
    }
}

struct RiverView_Previews: PreviewProvider {
    static var previews: some View {
        
        RiverView(backpackRepository: BackpackRepository.preview) {} goToFishing: { _ in }
    }
}
