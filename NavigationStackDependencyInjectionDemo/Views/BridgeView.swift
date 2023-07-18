//
//  BridgeView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI

struct BridgeView: View {
    
    @StateObject var viewModel: BridgeViewModel
    
    init(goToFishing: @escaping (@escaping ([String]) -> Void) -> Void) {
        
        self._viewModel = StateObject(wrappedValue: BridgeViewModel(goToFishing: goToFishing))
    }
    
    var body: some View {
        VStack {
            Text("You step into the middle of a sturdy stone bridge over the streaming waters")
            
            Button("Cast a line") {
                print("Go to fishing with view-model(\(viewModel.uuidString))")
                viewModel.goToFishing(viewModel.displayFish)
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
        BridgeView(goToFishing: { _ in })
    }
}

