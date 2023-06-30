//
//  BackpackRepository.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import Foundation


class BackpackRepository: ObservableObject {
    
    let id = UUID().uuidString
    @Published private var items: [String]
    
    init(items: [String] = []) {
        self.items = items
    }
    
    public func getItems() -> [String] {
        
        return items
    }
    
    
    public func add(item: String) {
        
        items.append(item)
    }
    
    
    static let preview = BackpackRepository(items: ["Flashlight", "Fishing Pole"])
    static let availableItemsToAdd = ["Flashlight", "Chalk", "Hook", "Pen", "Paper", "Notebook", "Pencil", "HalfEmpty Water Bottle", "Gum wrapper", "Scroll of Cthulu"]
}

