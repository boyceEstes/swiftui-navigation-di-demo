//
//  UIComposer.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI

/*
 *
 * It is repetetive to declare the classes because are going to need the navigationFlow in order to actually
 * setup the next destinations - but also to set the next destinations we need to have those next destination
 * views ready. Which would require far too much knowlege for just the HomeUIComposer. It would have dependencies
 * for laying out the entire app, including any nested hiearchies and all of their dependencies.
 *
 * Keep the navigation "simple" by coordinating the composition of the hierarchies in the root view of the app
 *
 * This composer class would be more necessary if we have some sort of logic to set up with the home view depedencies
 * like making an adapter, presentor or situational error view from here.
 *
 * Unitl then, it should be kept simple with the declarations of the views all being in one place.
 */

class HomeUIComposer {
    
    @StateObject static var homeNavigationFlow = NavigationFlow()

    static func makeHomeView(
        goToRiver: @escaping () -> Void
    ) -> some View {
        HomeView(goToRiver: goToRiver)
    }
}


class RiverUIComposer {
    
    static func makeRiverView(
        backpackRepository: BackpackRepository,
        goToBridge: @escaping () -> Void,
        goToFishing: @escaping () -> Void
    ) -> some View {
        RiverView(
            backpackRepository: backpackRepository,
            goToBridge: goToBridge,
            goToFishing: goToFishing
        )
    }
}
    
    
//    private init() {}
    
//
//    func makeHomeViewWithNavigation(
//        navigationFlow: Binding<NavigationFlow>,
//        backpackRepository: BackpackRepository
//    ) -> some View {
//
//        NavigationStack(path: navigationFlow.path) {
//            Button("Hello world") {
//                navigationFlow.
//            }
//                .navigationDestination(for: NavigationFlow.StackIdentifier.self) { identifier in
//                    Text("Next")
//                }
//        }
//    }

//class RiverUIComposer {
//
//    private init() {}
//
//    static func makeRiverView(backpackRepository: BackpackRepository, goToBridge: @escaping () -> Void) {
//
//        RiverView(backpackRepository: backpackRepository, goToBridge: <#T##() -> Void#>)
//    }
//}


//struct HomeViewWithNavigation: View {
//
//    let goToRiver: () -> Void
//    @ObservedObject var navigationFlow: NavigationFlow
//
//    var body: some View {
//
//        NavigationStack(path: $navigationFlow.path) {
//            HomeView(goToRiver: goToRiver)
//                .navigationDestination(for: NavigationFlow.StackIdentifier.self) { identifier in
//
//                    switch identifier {
//                    case .river(let backpackRepository):
////                        RiverView(backpackRepository: <#T##BackpackRepository#>, goToBridge: <#T##() -> Void#>)
//                        Text("Fake River View")
//                    case .bridge:
//                        BridgeView()
//                    }
//                }
//        }
//    }
//}


//static func makeHomeView(
//    navigationFlow: NavigationFlow,
//    backpackRepository: BackpackRepository
//) -> some View {
//
//    HomeView {
//        navigationFlow.push(view: .river(backpackRepository))
//    }
//}
