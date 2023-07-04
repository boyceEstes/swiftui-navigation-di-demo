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


class BridgeViewModel {
    
    let goToFishing: () -> Void
    var bridgeCaughtFish = [String]() {
        didSet {
            print("Look at the haul \(bridgeCaughtFish)")
        }
    }
    
    
    init(goToFishing: @escaping () -> Void) {
        
        self.goToFishing = goToFishing
    }
    
    
    func displayFish(caughtFish: [String]) {
        print("All the fish caught on the bridge! \(caughtFish)")
        bridgeCaughtFish = caughtFish
    }
}


class BridgeUIComposer {
    
    static func makeBridgeView(goToFishing: @escaping (@escaping HomeNavigationFlow.FinishFishing) -> Void) -> BridgeView {
        
        let bridgeViewModel = BridgeViewModel(goToFishing: {
            let bridgeViewModel = BridgeViewModel(goToFishing: {})
            goToFishing(bridgeViewModel.displayFish)
        })
        
        return BridgeView(viewModel: bridgeViewModel)
    }
}


class RiverUIComposer {
    
    static func makeRiverView(
        backpackRepository: BackpackRepository,
        goToBridge: @escaping () -> Void,
        goToFishing: @escaping (@escaping HomeNavigationFlow.FinishFishing) -> Void
    ) -> RiverView {
        
        RiverView(
            backpackRepository: backpackRepository,
            goToBridge: goToBridge,
            goToFishing: {
                goToFishing { caughtFish in
                    print("Finished fishing at the river, caught \(caughtFish)")
                }
            }
        )
    }
}


struct ContentView: View {
    
    @StateObject var backpackRepository = BackpackRepository()
    
    @StateObject var navigationFlow = HomeNavigationFlow()
    @StateObject var fishingNavigationFlow = FishingNavigationFlow()
    
    var body: some View {
//        TabView {
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
                        
                    case let .fishing(backpackRepository, finishFishing):
                        fishingView2(backpackRepository: backpackRepository, finishFishing: finishFishing)
                    }
                }
                .onChange(of: navigationFlow.displayedSheet) { newValue in
                    print("home flow: \(String(describing: newValue))")
                }
                .onChange(of: fishingNavigationFlow.displayedSheet) { newValue in
                    print("fishing flow: \(String(describing: newValue))")
                }
//                .tabItem {
//                    Label("Explore", systemImage: "mountain.2")
//                }
//
//            NavigationStack {
//                BackpackListView(backpackRepository: backpackRepository)
//            }
//                .tabItem {
//                    Label("Backpack", systemImage: "backpack")
//                }
//        }
    }
    
    
    private func goToRiver() {
        navigationFlow.push(.river(backpackRepository))
    }
    
    
    private func goToBridge() {
        navigationFlow.push(.bridge)
    }
    
    
    private func goToFishing(finishFishing: @escaping HomeNavigationFlow.FinishFishing) {
        navigationFlow.displayedSheet = .fishing(backpackRepository, finishFishing)
    }
    
    
    // MARK: - FishingNavigationFlow
    func fishingView2(
        backpackRepository: BackpackRepository,
        finishFishing: @escaping ([String]) -> Void
    ) -> some View {
        
        FishingView(
            backpackRepository: backpackRepository,
            goToBackpackItemDetail: goToBackpackItemDetail,
            goToFishDetail: goToFishDetail,
            goToNap: goToNap,
            finishFishing: finishFishing
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
