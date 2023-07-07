//
//  BridgeView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI

struct BridgeView: View {
    
    @ObservedObject var viewModel: BridgeViewModel
    
    var body: some View {
        VStack {
            Text("You step into the middle of a sturdy stone bridge over the streaming waters")
            
            Button("Cast a line") {
                print("Go to fishing with view-model(\(viewModel.uuidString))")
                viewModel.goToFishing($viewModel.bridgeCaughtFish)
            }
            .buttonStyle(BigDealButtonStyle(backgroundColor: .orange))
            List {
                ForEach(viewModel.bridgeCaughtFish, id: \.self) {
                    Text("\($0)")
                }
            }
        }
        .basicNavigationBar(title: "Bridge")
    }
}


struct BridgeView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeView(viewModel: BridgeViewModel(goToFishing: { _ in }))
    }
}

