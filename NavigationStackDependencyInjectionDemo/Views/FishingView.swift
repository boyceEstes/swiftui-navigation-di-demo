//
//  FishingView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI


struct FishingView: View {
    
    let potentialCatches = ["Snapper", "Carp", "Bass", "Trout", "Mudfish", "Jellyfish", "Halibut", "Goldfish"]
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var backpackRepository: BackpackRepository
    let goToBackpackItemDetail: (String) -> Void
    let goToFishDetail: (String) -> Void
    let goToNap: () -> Void
    let finishFishing: ([String]) -> Void
//
    @State private var catches = [String]()
    
    var body: some View {
        VStack {
            Text("You watch your bobber float in the water and enjoy the warm sun on your skin")

            Button("Finish Up") {
                finishAndDismissFishing()
            }
            .buttonStyle(BigDealButtonStyle())
            
            HStack {
                Button("Nap") {
                    goToNap()
                }
                .buttonStyle(BigDealButtonStyle(backgroundColor: .pink))
                
                Button("Yank'a'Fish") {
                    catches.append(potentialCatches.randomElement()!)
                }
                .buttonStyle(BigDealButtonStyle(backgroundColor: .orange))
            }
            
            
            List {
                Section {
                    ForEach(catches, id: \.self) { fish in
                        Button("\(fish)") {
                            goToFishDetail(fish)
                        }
                    }
                } header: {
                    HStack {
                        Text("Fish Caught")
                        Spacer()
                        Button("Pray for Fish") {
                            catches.append(potentialCatches.randomElement()!)
                        }
                        .font(.caption)
                        .foregroundColor(.orange)
                    }
                } footer: {
                    if catches.isEmpty {
                        Text("Playing the waiting game")
                    }
                }
                
                Section {
                    ForEach(backpackRepository.getItems(), id: \.self) { item in
                        
                        Button {
                            goToBackpackItemDetail(item)
                        } label: {
                            Text("\(item)")
                        }
                    }
                } header: {
                    HStack {
                        Text("Backpack Items")
                        Spacer()
                        Button("Add essential") {
                            backpackRepository.add(item: BackpackRepository.availableItemsToAdd.randomElement()!)
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                } footer: {
                    if backpackRepository.getItems().isEmpty {
                        Text("Nothing in backpack")
                    }
                }
            }
            Spacer()
        }
        .basicNavigationBar(title: "Fishing", navigationBarColor: .orange)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Finish up") {
                    finishAndDismissFishing()
                }
            }
        }
    }
    
    
    func finishAndDismissFishing() {
        print("Tapped finsh button")
        finishFishing(catches)
        dismiss()
    }
}


struct FishingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FishingView(
                backpackRepository: BackpackRepository.preview,
                goToBackpackItemDetail: { _ in },
                goToFishDetail: { _ in },
                goToNap: { },
                finishFishing: { _ in }
            )
        }
    }
}
