//
//  NavigationFlow.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import Foundation

protocol StackNavigationFlow: ObservableObject {
    
    associatedtype Identifier: Hashable
    
    var path: [Identifier] { get set }
    
    func push(_ viewIdentifier: Identifier)
}


extension StackNavigationFlow {
    
    
    func push(_ viewIdentifier: Identifier) {

        path.append(viewIdentifier)
    }
}


class NavigationFlow: StackNavigationFlow {
    
    // MARK: Properties
    @Published var path = [StackIdentifier]()

    
    // MARK: Stack Destinations
    enum StackIdentifier: Hashable {
        
//        case home
        case river(BackpackRepository)
        case bridge
        
        static func == (lhs: NavigationFlow.StackIdentifier, rhs: NavigationFlow.StackIdentifier) -> Bool {
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
}


class FishingNavigationFlow: StackNavigationFlow {
    
    // MARK: Properties
    @Published var path = [StackIdentifier]()
    
    
    enum StackIdentifier: Hashable {
        
        case fishDetail(String)
        case backpackItemDetail(String)
    }
}


enum SheetyIdentifier: Identifiable {
    case fishing(BackpackRepository)
    
    var id: String {
        switch self {
        case .fishing(let backpackRepository):
            return "fishing-\(backpackRepository.id)"
        }
    }
}
