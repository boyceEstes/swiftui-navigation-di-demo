//
//  NavigationFlow.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import Foundation

protocol StackNavigationFlow: ObservableObject {
    
    associatedtype StackIdentifier: Hashable
    
    var path: [StackIdentifier] { get set }
    
    func push(_ viewIdentifier: StackIdentifier)
}


extension StackNavigationFlow {
    
    
    func push(_ viewIdentifier: StackIdentifier) {

        path.append(viewIdentifier)
    }
}



protocol SheetyNavigationFlow: ObservableObject {
    
    associatedtype SheetyIdentifier: Identifiable
    
    var displayedSheet: SheetyIdentifier? { get set }
}



// APP-SPECIFIC

class HomeNavigationFlow: StackNavigationFlow {
    
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
//            case .home:
//                hasher.combine("home")
            case .river(let backpackRepository):
                hasher.combine("river" + backpackRepository.id)
            case .bridge:
                hasher.combine("bridge")
            }
        }
    }
    
    
    // MARK: Sheety Display
    enum SheetyIdentifier: Identifiable {
        case fishing(BackpackRepository)
        
        var id: String {
            switch self {
            case .fishing(let backpackRepository):
                return "fishing-\(backpackRepository.id)"
            }
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
    enum SheetyFishIdentifier: Identifiable {
        case nap
        
        var id: String {
            switch self {
            case .nap: return "nap"
            }
        }
    }
}
