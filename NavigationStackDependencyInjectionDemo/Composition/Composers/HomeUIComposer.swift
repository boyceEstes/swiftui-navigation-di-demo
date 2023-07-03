//
//  UIComposer.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI


class HomeUIComposer { }

class RiverUIComposer: ObservableObject {
    
    enum SheetyDestination: Identifiable {
        
        case fishing(BackpackRepository)
        
        var id: String {
            switch self {
            case .fishing(let backpackRepository):
                return "fishing-\(backpackRepository.id)"
            }
        }
    }
    
    @Published var displayedSheet: SheetyDestination?
    
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
