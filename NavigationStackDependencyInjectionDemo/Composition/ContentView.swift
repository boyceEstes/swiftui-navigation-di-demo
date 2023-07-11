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
    @Published var bridgeCaughtFish = ["testing", "testing2"]
    
    let goToFishing: (@escaping ([String]) -> Void) -> Void
    
    
    init(goToFishing: @escaping (@escaping ([String]) -> Void) -> Void) {
        
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
    
    static func makeBridgeView(goToFishing: @escaping (@escaping ([String]) -> Void) -> Void) -> BridgeView {
        
        let bridgeViewModel = BridgeViewModel(goToFishing: goToFishing)
        return BridgeView(viewModel: bridgeViewModel)
    }
}


class RiverUIComposer {
    
    static func makeRiverView(
        backpackRepository: BackpackRepository,
        goToBridge: @escaping () -> Void,
        goToFishing: @escaping (@escaping ([String]) -> Void) -> Void
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
    
//    @State private var navigationFlow = HomeNavigationFlow()
    @State private var homeNavigationFlowPath = [HomeNavigationFlow.StackIdentifier]()
    @State private var homeNavigationFlowDisplayedSheet: HomeNavigationFlow.SheetyIdentifier?
    
    @StateObject var fishingNavigationFlow = FishingNavigationFlow()
    @StateObject var backpackNavigationFlow = BackpackListNavigationFlow()
    
    
    init(backpackRepository: BackpackRepository) {
        
        self.backpackRepository = backpackRepository
    }
    
    
    var body: some View {
        TabView {
            
            HomeView(goToRiver: goToRiver)
                .flowNavigationDestination(flowPath: $homeNavigationFlowPath) { identifier in
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
                .sheet(item: $homeNavigationFlowDisplayedSheet) { sheetyDestination in
                    switch sheetyDestination {

                    case let .fishing(backpackRepository, finishFishing):
                        fishingView2(backpackRepository: backpackRepository, finishFishing: finishFishing)
                    }
                }
            // Use the onChange method for debugging correct state of navigation flows
                .onChange(of: homeNavigationFlowDisplayedSheet) { newValue in
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
//        navigationFlow.push(.river(backpackRepository))
        homeNavigationFlowPath.append(.river(backpackRepository))
    }
    
    
    private func goToBridge() {
//        navigationFlow.push(.bridge)
        homeNavigationFlowPath.append(.bridge)
    }
    
    
    private func goToFishing(fishingCompletion: @escaping ([String]) -> Void) {
        homeNavigationFlowDisplayedSheet = .fishing(backpackRepository, fishingCompletion)
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
//            caughtFish: caughtFish
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
            homeNavigationFlowDisplayedSheet = nil
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
