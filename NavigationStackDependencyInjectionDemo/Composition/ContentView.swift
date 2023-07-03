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
    
    func displayFish(caughtFish: [String]) {
        print("All the fish caught on the bridge! \(caughtFish)")
    }
}


class BridgeUIComposer {
    
    static func makeBridgeView(goToFishing: @escaping (@escaping HomeNavigationFlow.FinishFishing) -> Void) -> BridgeView {
        
        let bridgeViewModel = BridgeViewModel()
        
        return BridgeView {
            goToFishing(bridgeViewModel.displayFish)
        }
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


//class FishingUIComposer {
//
//    static func makeFishingView(finishFishing: ([String]) -> Void) -> FishingView {
//
//        FishingView(
//            backpackRepository: backpackRepository,
//            goToBackpackItemDetail: goToBackPackItemDetail,
//            goToFishDetail: goToFishDetail,
//            goToNap: goToNap,
//            finishFishing: finishFishing
//        )
//    }
//}


struct ContentView: View {
    
    @StateObject var backpackRepository = BackpackRepository()
    
    @StateObject var navigationFlow = HomeNavigationFlow()
    @StateObject var fishingNavigationFlow = FishingNavigationFlow()
    
    var body: some View {
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
    func fishingView2(backpackRepository: BackpackRepository, finishFishing: @escaping ([String]) -> Void) -> some View {

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
                NapView()
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
