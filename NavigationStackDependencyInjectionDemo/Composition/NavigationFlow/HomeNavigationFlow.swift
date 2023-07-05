//
//  NavigationFlow.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import Foundation


// APP-SPECIFIC

class HomeNavigationFlow: StackNavigationFlow, SheetyNavigationFlow {
    
    // MARK: Properties
    @Published var path = [StackIdentifier]()
    @Published var displayedSheet: SheetyIdentifier?

    
    // MARK: Stack Destinations
    enum StackIdentifier: Hashable {
        
//        case home
        case river(BackpackRepository)
        case bridge
        
        static func == (lhs: HomeNavigationFlow.StackIdentifier, rhs: HomeNavigationFlow.StackIdentifier) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .river(let backpackRepository):
                hasher.combine("river" + backpackRepository.id)
            case .bridge:
                hasher.combine("bridge")
            }
        }
    }
    
    
    // MARK: Sheety Display
    // I made this Equatable to test `onChange` property
    typealias FinishFishing = ([String]) -> Void
    
    enum SheetyIdentifier: Identifiable, Equatable {
        case fishing(BackpackRepository, FinishFishing)
        
        var id: String {
            switch self {
            case let .fishing(backpackRepository, _):
                return "fishing-\(backpackRepository.id)"
            }
        }
        
        static func == (lhs: HomeNavigationFlow.SheetyIdentifier, rhs: HomeNavigationFlow.SheetyIdentifier) -> Bool {
            lhs.id == rhs.id
        }
    }
}


class FishingNavigationFlow: StackNavigationFlow, SheetyNavigationFlow {
    

    // MARK: Properties
    @Published var path = [StackFishIdentifier]()
    @Published var displayedSheet: SheetyFishIdentifier?
    
    
    // MARK: Stack Views
    enum StackFishIdentifier: Hashable {
        
        case fishDetail(String)
        case backpackItemDetail(String)
    }
    
    // MARK: Sheet Views
    // I made this Equatable to test `onChange` property
    enum SheetyFishIdentifier: Identifiable, Equatable {
        
        case nap
        
        var id: String {
            switch self {
            case .nap: return "nap"
            }
        }
    }
}


class BackpackListNavigationFlow: StackNavigationFlow {
    
    // MARK: Properties
    @Published var path = [StackIdentifier]()
    
    // MARK: Stack Destinations
    enum StackIdentifier: Hashable {
        case backpackItemDetail(String)
    }
}
