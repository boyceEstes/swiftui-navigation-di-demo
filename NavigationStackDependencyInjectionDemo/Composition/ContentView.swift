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
    
    @StateObject var riverUIComposer = RiverUIComposer()
    
    var body: some View {

//        NavigationStack(path: $navigationFlow.path) {
            
            HomeView(goToRiver: goToRiver)
                .modifier(
                    FlowNavigationDestination(flowPath: $navigationFlow.path) { identifier in
                        switch identifier {
                        case let .river(backpackRepository):
                            RiverView(
                                backpackRepository: backpackRepository,
                                goToBridge: goToBridge,
                                goToFishing: goToFishingFromRiver
                            )
                            .sheet(item: $riverUIComposer.displayedSheet) { sheetyDestination in
                                switch sheetyDestination {
                                    
                                case .fishing(let backpackRepository):
                                    fishingView(backpackRepository: backpackRepository)
                                    
//                                    FishingView(
//                                        backpackRepository: backpackRepository,
//                                        goToBackpackItemDetail: goToBackpackItemDetail,
//                                        goToFishDetail: goToFishDetail
//                                    )
////                                    .modifier(
//                                        FlowNavigationDestination(flowPath: $fishingNavigationFlow.path) { identifier in
//
//                                            switch identifier {
//                                            case .fishDetail(let fish):
////                                                FishDetailView(fish: fish)
//                                                Text("Fish detail")
//
//                                            case .backpackItemDetail(let item):
////                                                BackpackItemDetailView(item: item)
//                                                Text("BackpackDetail")
//                                            }
//                                        }
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
//                                    )
                                }
                            }
                        case .bridge:
                            
                            BridgeView(goToFishing: goToFishingFromRiver)
                        }
                    }
                )
//            .modifier(FlowNavigationDestination(flowPath: $navigationFlow.path) )
//        }
            /*
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
                    case .bridge:
                        BridgeView(
                            goToFishing: sheetyGoToFishing
                        )
                        .modifier(
                            LevelOneSheet(
                                displayedSheet: $levelOneDisplayedSheet,
                                navigationFlowPath: $fishingNavigationFlow.path
                            )
                        )
//                            .sheet(item: $levelOneDisplayedSheet) { identifier in
//
//                                switch identifier {
//                                case .fishing(let backpackRepository):
//
//                                    NavigationStack(path: $fishingNavigationFlow.path) {
//                                        FishingView(
//                                            backpackRepository: backpackRepository,
//                                            goToBackpackItemDetail: goToBackpackItemDetail,
//                                            goToFishDetail: goToFishDetail
//                                        )
//                                            .navigationDestination(for: FishingNavigationFlow.StackIdentifier.self) { identifier in
//
//                                                switch identifier {
//                                                case .fishDetail(let fish):
//                                                    FishDetailView(fish: fish)
//
//                                                case .backpackItemDetail(let item):
//                                                    BackpackItemDetailView(item: item)
//                                                }
//                                            }
//                                    }
//                                }
//                            }
                    }
                }
        }
//        HomeViewWithNavigation(goToRiver: goToRiver, navigationFlow: navigationFlow)
        */
    }
    

    private func goToRiver() {
        navigationFlow.push(.river(backpackRepository))
    }
    
    
    private func goToBridge() {
        navigationFlow.push(.bridge)
    }
    
    

    private func goToFishingFromRiver() {
        riverUIComposer.displayedSheet = .fishing(backpackRepository)
    }
    
    
    // MARK: - FishingNavigationFlow
    private func goToFishDetail(fish: String) {
        fishingNavigationFlow.push(view: .fishDetail(fish))
    }
    
    
    private func goToBackpackItemDetail(item: String) {
        fishingNavigationFlow.push(view: .backpackItemDetail(item))
    }
    
    func fishingView(backpackRepository: BackpackRepository) -> some View {
        
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
    
    
//    func fishingView2(backpackRepository: BackpackRepository) -> some View {
//
//        FishingView(
//            backpackRepository: backpackRepository,
//            goToBackpackItemDetail: goToBackpackItemDetail,
//            goToFishDetail: goToFishDetail
//        )
//        .modifier(
//            FlowNavigationDestination(
//                flowPath: $fishingNavigationFlow.path) { id in
//                }
//        )
//
//            .navigationDestination(for: FishingNavigationFlow.StackIdentifier.self) { identifier in
//                switch identifier {
//                case .fishDetail(let fish):
//                    FishDetailView(fish: fish)
//
//                case .backpackItemDetail(let item):
//                    BackpackItemDetailView(item: item)
//                }
//            }
//        }
//    }
    
}


struct FlowNavigationDestination<DestinationContent: View>: ViewModifier {
    
    @Binding var flowPath: [NavigationFlow.StackIdentifier]
    @ViewBuilder let flowDestination: (NavigationFlow.StackIdentifier) -> DestinationContent
    
    func body(content: Content) -> some View {
        
        NavigationStack(path: $flowPath) {
            content
                .navigationDestination(for: NavigationFlow.StackIdentifier.self, destination: flowDestination)
        }
    }
}


//extension View {
//
//    func flowNavigationDestination(flowPath: Binding<[NavigationFlow.StackIdentifier]>) -> some View {
//
//        modifier(
//            FlowNavigationDestination(flowPath: flowPath)
//        )
//    }
//}

struct FlowSheet<SheetContent: View>: ViewModifier {
    
    @Binding var displayFlowSheet: SheetyIdentifier?
    @ViewBuilder let displayFlowSheetContent: (SheetyIdentifier) -> SheetContent
    
    func body(content: Content) -> some View {
        
        content
            .sheet(item: $displayFlowSheet, content: displayFlowSheetContent)
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
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
