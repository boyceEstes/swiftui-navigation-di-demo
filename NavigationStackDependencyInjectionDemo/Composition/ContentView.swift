//
//  ContentView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI

/*
 * This is the root view where everything should be created and displayed
 */

/*
 * Create a new NavigationFlow for each stack hierarchy that is needed
 */

struct ContentView: View {
    
    @StateObject var backpackRepository = BackpackRepository()
    @State private var levelOneDisplayedSheet: SheetyIdentifier?
    
    @StateObject var navigationFlow = NavigationFlow()
    @StateObject var fishingNavigationFlow = FishingNavigationFlow()
    
    var body: some View {

        NavigationStack(path: $navigationFlow.path) {
            
            HomeView(goToRiver: goToRiver)
                .navigationDestination(for: NavigationFlow.StackIdentifier.self) { identifier in
                    
                    switch identifier {
                    case .river(let backpackRepository):
                        
                        RiverView(
                            backpackRepository: backpackRepository,
                            goToBridge: goToBridge,
                            goToFishing: sheetyGoToFishing
                        )
                        .modifier(
                            LevelOneSheet(
                                displayedSheet: $levelOneDisplayedSheet,
                                navigationFlowPath: $fishingNavigationFlow.path
                            )
                        )
//                        .sheet(item: $levelOneDisplayedSheet) { identifier in
//
//                            switch identifier {
//                            case .fishing(let backpackRepository):
//
//                                NavigationStack(path: $fishingNavigationFlow.path) {
//                                    FishingView(
//                                        backpackRepository: backpackRepository,
//                                        goToBackpackItemDetail: goToBackpackItemDetail,
//                                        goToFishDetail: goToFishDetail
//                                    )
//                                        .navigationDestination(for: FishingNavigationFlow.StackIdentifier.self) { identifier in
//
//                                            switch identifier {
//                                            case .fishDetail(let fish):
//                                                FishDetailView(fish: fish)
//
//                                            case .backpackItemDetail(let item):
//                                                BackpackItemDetailView(item: item)
//                                            }
//                                        }
//                                }
//                            }
//                        }
                    case .bridge:
                        BridgeView(
                            goToFishing: sheetyGoToFishing
                        )
                            .sheet(item: $levelOneDisplayedSheet) { identifier in
                                
                                switch identifier {
                                case .fishing(let backpackRepository):
                                    
                                    NavigationStack(path: $fishingNavigationFlow.path) {
                                        FishingView(
                                            backpackRepository: backpackRepository,
                                            goToBackpackItemDetail: goToBackpackItemDetail,
                                            goToFishDetail: goToFishDetail
                                        )
                                            .navigationDestination(for: FishingNavigationFlow.StackIdentifier.self) { identifier in
                                                
                                                switch identifier {
                                                case .fishDetail(let fish):
                                                    FishDetailView(fish: fish)
                                                    
                                                case .backpackItemDetail(let item):
                                                    BackpackItemDetailView(item: item)
                                                }
                                            }
                                    }
                                }
                            }
                    }
                }
        }
//        HomeViewWithNavigation(goToRiver: goToRiver, navigationFlow: navigationFlow)
    }
    

    private func goToRiver() {
        navigationFlow.push(view: .river(backpackRepository))
    }
    
    
    private func goToBridge() {
        navigationFlow.push(view: .bridge)
    }
    
    
    private func sheetyGoToFishing() {
        levelOneDisplayedSheet = .fishing(backpackRepository)
    }
    
    
    // MARK: - FishingNavigationFlow
    private func goToFishDetail(fish: String) {
        fishingNavigationFlow.push(view: .fishDetail(fish))
    }
    
    
    private func goToBackpackItemDetail(item: String) {
        fishingNavigationFlow.push(view: .backpackItemDetail(item))
    }
    
    
}

struct LevelOneSheet: ViewModifier {
    
    @Binding var displayedSheet: SheetyIdentifier?
    @Binding var navigationFlowPath: [FishingNavigationFlow.StackIdentifier] // TODO: Make protocol some NavigationPathObject
    
    // MARK: - FishingNavigationFlow
    private func goToFishDetail(fish: String) {
        navigationFlowPath.append(.fishDetail(fish))
    }
    
    
    private func goToBackpackItemDetail(item: String) {
        navigationFlowPath.append(.backpackItemDetail(item))
    }
    
    
    func body(content: Content) -> some View {
        content.sheet(item: $displayedSheet) { identifier in

            switch identifier {
            case .fishing(let backpackRepository):
                NavigationStack(path: $navigationFlowPath) {
                    FishingView(
                        backpackRepository: backpackRepository,
                        goToBackpackItemDetail: goToBackpackItemDetail,
                        goToFishDetail: goToFishDetail
                    )
                    .navigationDestination(for: FishingNavigationFlow.StackIdentifier.self) { identifier in
                        switch identifier {
                        case .fishDetail(let fish):
                            FishDetailView(fish: fish)
                            
                        case .backpackItemDetail(let item):
                            BackpackItemDetailView(item: item)
                        }
                    }
                }
            }
//            switch identifier {
//            case .fishing(let backpackRepository):
//
//                NavigationStack(path: $navigationFlowPath) {
//                    FishingView(
//                        backpackRepository: backpackRepository,
//                        goToBackpackItemDetail: { _ in },
//                        goToFishDetail: { _ in }
//                    )
//                        .navigationDestination(for: FishingNavigationFlow.StackIdentifier.self) { identifier in
//
//                            switch identifier {
//                            case .fishDetail(let fish):
//                                FishDetailView(fish: fish)
//
//                            case .backpackItemDetail(let item):
//                                BackpackItemDetailView(item: item)
//                            }
//                        }
//                }
//            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
