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
    
    @StateObject var navigationFlow = NavigationFlow()
    @StateObject var fishingNavigationFlow = FishingNavigationFlow()
    
    var body: some View {
        HomeUIComposer.makeHomeView(goToRiver: goToRiver)
            .flowNavigationDestination(flowPath: $navigationFlow.path) { identifier in
                switch identifier {
                case let .river(backpackRepository):
                    RiverView(
                        backpackRepository: backpackRepository,
                        goToBridge: goToBridge,
                        goToFishing: goToFishingFromRiver
                    )
                case .bridge:

                    BridgeView(goToFishing: goToFishingFromRiver)
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
    

    private func goToFishingFromRiver() {
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


struct FlowNavigationDestination<DestinationContent: View, StackIdentifier: Hashable>: ViewModifier {
    
    @Binding var flowPath: [StackIdentifier]
    @ViewBuilder let flowDestination: (StackIdentifier) -> DestinationContent
    
    init(
        flowPath: Binding<[StackIdentifier]>,
        @ViewBuilder flowDestination: @escaping (StackIdentifier) -> DestinationContent
    ) {
        self._flowPath = flowPath
        self.flowDestination = flowDestination
    }
    
    func body(content: Content) -> some View {
        
        NavigationStack(path: $flowPath) {
            content
                .navigationDestination(for: StackIdentifier.self, destination: flowDestination)
        }
    }
}


extension View {
    
    func flowNavigationDestination<DestinationContent: View, StackIdentifier: Hashable> (
        flowPath: Binding<[StackIdentifier]>,
        @ViewBuilder flowDestination: @escaping (StackIdentifier) -> DestinationContent
    ) -> some View {
        
        modifier(
            FlowNavigationDestination(flowPath: flowPath, flowDestination: flowDestination)
        )
    }
}

//
//struct FlowSheet<SheetContent: View>: ViewModifier {
//
//    @Binding var displayFlowSheet: SheetyIdentifier?
//    @ViewBuilder let displayFlowSheetContent: (SheetyIdentifier) -> SheetContent
//
//    func body(content: Content) -> some View {
//
//        content
//            .sheet(item: $displayFlowSheet, content: displayFlowSheetContent)
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
