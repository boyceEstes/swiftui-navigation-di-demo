//
//  HomeView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI


struct HomeView: View {
    
    let goToRiver: () -> Void
    
    var body: some View {
        VStack {
            Text("You see a cozy home nestled in a clearing of trees")
            
            Button {
                goToRiver()
            } label: {
                Text("Head to The River")
            }
            .buttonStyle(BigDealButtonStyle())
        }
        .basicNavigationBar(title: "Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView(goToRiver: { print("goToRiver") })
    }
}
