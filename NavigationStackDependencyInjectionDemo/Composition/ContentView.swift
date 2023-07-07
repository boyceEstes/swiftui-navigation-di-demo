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


class BridgeViewModel: ObservableObject {
    
    let uuidString = UUID().uuidString
    @Published var bridgeCaughtFish = [String]()
    
    let goToFishing: (Binding<[String]>) -> Void
    
    
    init(goToFishing: @escaping (Binding<[String]>) -> Void) {
        
        self.goToFishing = goToFishing
        print("init bridgeViewModel(\(uuidString))")
    }
    
    
    deinit {
        print("deinit bridgeViewModel(\(uuidString))")
    }
    
    
    func displayFish(caughtFish: [String]) {
        print("All the fish caught on the bridge view-model(\(uuidString)! \(caughtFish)")
        bridgeCaughtFish = caughtFish
    }
}


class BridgeUIComposer {
    
    static func makeBridgeView(goToFishing: @escaping (Binding<[String]>) -> Void) -> BridgeView {
        
        let bridgeViewModel = BridgeViewModel(goToFishing: goToFishing)
        return BridgeView(viewModel: bridgeViewModel)
    }
}


class RiverUIComposer {
    
    static func makeRiverView(
        backpackRepository: BackpackRepository,
        goToBridge: @escaping () -> Void,
        goToFishing: @escaping (Binding<[String]>) -> Void
    ) -> RiverView {
        
        RiverView(
            backpackRepository: backpackRepository,
            goToBridge: goToBridge,
            goToFishing: goToFishing
        )
    }
}


struct ContentView: View {
    
    @ObservedObject var backpackRepository: BackpackRepository
    
    @StateObject var navigationFlow = HomeNavigationFlow()
    @StateObject var fishingNavigationFlow = FishingNavigationFlow()
    @StateObject var backpackNavigationFlow = BackpackListNavigationFlow()
    
    
    init(backpackRepository: BackpackRepository) {
        
        self.backpackRepository = backpackRepository
    }
    
    
    var body: some View {
        TabView {
//            NavigationStack(path: $navigationFlow.path) {
//                HomeView(goToRiver: goToRiver)
//                    .navigationDestination(for: HomeNavigationFlow.StackIdentifier.self) { identifier in
//
//                        switch identifier {
//                        case .bridge:
//                            let viewModel = BridgeViewModel(goToFishing: {
//                                let bridgeViewModel = BridgeViewModel(goToFishing: {})
//                                goToFishing(finishFishing: bridgeViewModel.displayFish)
//                            })
//
//                            BridgeView(viewModel: viewModel)
//                        }
//                    }
//                    .sheet(item: $navigationFlow.displayedSheet) { sheetyDestination in
//                        switch sheetyDestination {
//
//                        case let .fishing(backpackRepository, finishFishing):
//                            fishingView2(backpackRepository: backpackRepository, finishFishing: finishFishing)
//                        }
//                    }
//            }
            
            HomeView(goToRiver: goToRiver)
                .flowNavigationDestination(flowPath: $navigationFlow.path) { identifier in
                    switch identifier {
                    case let .river(backpackRepository):
                        RiverUIComposer.makeRiverView(
                            backpackRepository: backpackRepository,
                            goToBridge: goToBridge,
                            goToFishing: goToFishing
                        )
                    case .bridge:
                        BridgeUIComposer.makeBridgeView(goToFishing: goToFishing)
                    }
                }
                .sheet(item: $navigationFlow.displayedSheet) { sheetyDestination in
                    switch sheetyDestination {

                    case let .fishing(backpackRepository, caughtFish):
                        fishingView2(backpackRepository: backpackRepository, caughtFish: caughtFish)
                    }
                }
            // Use the onChange method for debugging correct state of navigation flows
                .onChange(of: navigationFlow.displayedSheet) { newValue in
                    print("home flow: \(String(describing: newValue))")
                }
                .onChange(of: fishingNavigationFlow.displayedSheet) { newValue in
                    print("fishing flow: \(String(describing: newValue))")
                }
                .tabItem {
                    Label("Explore", systemImage: "mountain.2")
                }

                BackpackListView(
                    backpackRepository: backpackRepository,
                    goToBackpackItemDetail: goToBackpackItemDetailFromBackpackList
                )
                .flowNavigationDestination(flowPath: $backpackNavigationFlow.path, flowDestination: { identifier in
                    switch identifier {
                    case let .backpackItemDetail(item):
                        BackpackItemDetailView(item: item)
                    }
                })
                .tabItem {
                    Label("Backpack", systemImage: "backpack")
                }
        }
    }
    
    
    private func goToRiver() {
        navigationFlow.push(.river(backpackRepository))
    }
    
    
    private func goToBridge() {
        navigationFlow.push(.bridge)
    }
    
    
    private func goToFishing(caughtFish: Binding<[String]>) {
        navigationFlow.displayedSheet = .fishing(backpackRepository, caughtFish)
    }
    
    
    // MARK: - FishingNavigationFlow
    func fishingView2(
        backpackRepository: BackpackRepository,
        caughtFish: Binding<[String]>
    ) -> some View {
        
        FishingView(
            backpackRepository: backpackRepository,
            goToBackpackItemDetail: goToBackpackItemDetail,
            goToFishDetail: goToFishDetail,
            goToNap: goToNap,
            caughtFish: caughtFish
//            finishFishing: finishFishing
        )
        .flowNavigationDestination(
            flowPath: $fishingNavigationFlow.path,
            flowDestination: { identifier in
                switch identifier {
                case .fishDetail(let fish):
                    FishDetailView(fish: fish)
                    
                case .backpackItemDetail(let item):
                    BackpackItemDetailView(item: item)
                }
            }
        )
        .sheet(item: $fishingNavigationFlow.displayedSheet) { identifier in
            switch identifier {
            case .nap:
                NapView(dismissAllSheets: dismissFishingAndHomeSheets)
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    
    private func goToFishDetail(fish: String) {
        fishingNavigationFlow.push(.fishDetail(fish))
    }
    
    
    private func goToBackpackItemDetail(item: String) {
        fishingNavigationFlow.push(.backpackItemDetail(item))
    }
    
    
    private func goToNap() {
        fishingNavigationFlow.displayedSheet = .nap
    }
    
    
    func dismissFishingAndHomeSheets() {
        Task {
            await fishingNavigationFlow.dismiss()
            await navigationFlow.dismiss()
        }
    }
    
    
    private func goToBackpackItemDetailFromBackpackList(item: String) {
        backpackNavigationFlow.push(.backpackItemDetail(item))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(backpackRepository: BackpackRepository.preview)
    }
}
