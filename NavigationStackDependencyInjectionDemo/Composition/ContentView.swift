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
    
    @StateObject var navigationFlow = HomeNavigationFlow()
    @StateObject var fishingNavigationFlow = FishingNavigationFlow()
    
    var body: some View {
        HomeView(goToRiver: goToRiver)
            .flowNavigationDestination(flowPath: $navigationFlow.path) { identifier in
                switch identifier {
                case let .river(backpackRepository):
                    RiverView(
                        backpackRepository: backpackRepository,
                        goToBridge: goToBridge,
                        goToFishing: goToFishing
                    )
                case .bridge:
                    BridgeView(goToFishing: goToFishing)
                }
            }
            .sheet(item: $navigationFlow.displayedSheet) { sheetyDestination in
                switch sheetyDestination {
                    
                case .fishing(let backpackRepository):
                    fishingView2(backpackRepository: backpackRepository)
                }
            }
    }
    

    private func goToRiver() {
        navigationFlow.push(.river(backpackRepository))
    }
    
    
    private func goToBridge() {
        navigationFlow.push(.bridge)
    }
    

    private func goToFishing() {
        navigationFlow.displayedSheet = .fishing(backpackRepository)
    }
    
    
    // MARK: - FishingNavigationFlow
    func fishingView2(backpackRepository: BackpackRepository) -> some View {

        FishingView(
            backpackRepository: backpackRepository,
            goToBackpackItemDetail: goToBackpackItemDetail,
            goToFishDetail: goToFishDetail,
            goToNap: goToNap
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
