//
//  BridgeView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI

struct BridgeView: View {
    
    let viewModel: BridgeViewModel
    
    var body: some View {
        VStack {
            Text("You step into the middle of a sturdy stone bridge over the streaming waters")
            Button("Cast a line") {
                viewModel.goToFishing()
            }
            .buttonStyle(BigDealButtonStyle(backgroundColor: .orange))
        }

        
            .basicNavigationBar(title: "Bridge")
    }
}


struct BridgeView_Previews: PreviewProvider {
    static var previews: some View {
        BridgeView(viewModel: BridgeViewModel(goToFishing: { }))
    }
}

